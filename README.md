[![Build Status](https://travis-ci.org/bewest/npm-vendorize-brunch.png)](https://travis-ci.org/bewest/npm-vendorize-brunch)

## npm-vendorize-brunch

Include npm sources in your brunch vendor output.

If you put, eg
```json
  "dependencies":  {
    "dc": "> 1.0.0"
  }
```
NPM will install the browser client dc.js in `node\_modules`, and it'd
be nice to have a way to include npm installed sources in the compiled
brunch output.

config.coffee
```coffee
exports.config =
  plugins:
    vendorize:
      dc:
        include: 'dc.js'
```
This plugin passes 'dc/dc.js' to `require.resolve`, and returns the
result to brunch via the plugin `include` method.

Very crude, but seems to work for npm sources that have a compiled
file that is ready for minification/include.

## Usage

Add `"npm-vendorize-brunch": "x.y.z"` to `package.json` of your brunch app.
Add config as shown above.

