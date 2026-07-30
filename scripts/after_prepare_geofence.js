#!/usr/bin/env node
/**
 * Applies INSTALL_DENGAGE_GEOFENCE (default: false) after prepare:
 * - Android: writes INSTALL_DENGAGE_GEOFENCE=… to platforms/android/gradle.properties
 * - iOS: injects / removes the DengageGeofence pod block in platforms/ios/Podfile
 *
 * Opt in from the app config.xml:
 *   <preference name="INSTALL_DENGAGE_GEOFENCE" value="true" />
 */
const fs = require('fs');
const path = require('path');

const IOS_GEOFENCE_BEGIN = '# BEGIN cordova-plugin-dengage INSTALL_DENGAGE_GEOFENCE';
const IOS_GEOFENCE_END = '# END cordova-plugin-dengage INSTALL_DENGAGE_GEOFENCE';
const IOS_GEOFENCE_POD = [
  IOS_GEOFENCE_BEGIN,
  "pod 'DengageGeofence', :git => 'https://github.com/dengage-tech/dengage-ios-sdk.git', :branch => 'version/5.100'",
  IOS_GEOFENCE_END,
].join('\n');

function readPreference(projectRoot) {
  let value = 'false';
  try {
    const configPath = path.join(projectRoot, 'config.xml');
    const xml = fs.readFileSync(configPath, 'utf8');
    const match =
      xml.match(/preference[^>]*name=["']INSTALL_DENGAGE_GEOFENCE["'][^>]*value=["']([^"']+)["']/i) ||
      xml.match(/preference[^>]*value=["']([^"']+)["'][^>]*name=["']INSTALL_DENGAGE_GEOFENCE["']/i);
    if (match) {
      value = match[1];
    }
  } catch (e) {
    // keep default false
  }
  return String(value).toLowerCase() === 'true' ? 'true' : 'false';
}

function applyAndroid(projectRoot, value) {
  const gradleProps = path.join(projectRoot, 'platforms', 'android', 'gradle.properties');
  if (!fs.existsSync(gradleProps)) {
    return;
  }

  let contents = fs.readFileSync(gradleProps, 'utf8');
  const line = `INSTALL_DENGAGE_GEOFENCE=${value}`;
  if (/^INSTALL_DENGAGE_GEOFENCE=.*/m.test(contents)) {
    contents = contents.replace(/^INSTALL_DENGAGE_GEOFENCE=.*/m, line);
  } else {
    contents = contents.trimEnd() + `\n\n# Dengage geofence (opt-in; default false)\n${line}\n`;
  }
  fs.writeFileSync(gradleProps, contents);
  console.log(`[cordova-plugin-dengage] Android ${line}`);
}

function applyIos(projectRoot, value) {
  const podfile = path.join(projectRoot, 'platforms', 'ios', 'Podfile');
  if (!fs.existsSync(podfile)) {
    return;
  }

  let contents = fs.readFileSync(podfile, 'utf8');
  const blockRe = new RegExp(
    `${IOS_GEOFENCE_BEGIN}[\\s\\S]*?${IOS_GEOFENCE_END}\\n?`,
    'm'
  );
  contents = contents.replace(blockRe, '');

  if (value === 'true') {
    // Insert inside the first target block when possible; otherwise append.
    const targetMatch = contents.match(/target\s+['"][^'"]+['"]\s+do/);
    if (targetMatch) {
      const insertAt = targetMatch.index + targetMatch[0].length;
      contents =
        contents.slice(0, insertAt) +
        `\n  ${IOS_GEOFENCE_POD.replace(/\n/g, '\n  ')}\n` +
        contents.slice(insertAt);
    } else {
      contents = contents.trimEnd() + `\n\n${IOS_GEOFENCE_POD}\n`;
    }
  }

  fs.writeFileSync(podfile, contents);
  console.log(
    `[cordova-plugin-dengage] iOS INSTALL_DENGAGE_GEOFENCE=${value}` +
      (value === 'true' ? ' (DengageGeofence pod injected)' : ' (DengageGeofence pod not installed)')
  );
}

module.exports = function (ctx) {
  const projectRoot = ctx.opts.projectRoot;
  const value = readPreference(projectRoot);
  const platforms = (ctx.opts.platforms || []).map((p) => String(p).toLowerCase());

  if (platforms.length === 0 || platforms.some((p) => p.includes('android'))) {
    applyAndroid(projectRoot, value);
  }
  if (platforms.length === 0 || platforms.some((p) => p.includes('ios'))) {
    applyIos(projectRoot, value);
  }
};
