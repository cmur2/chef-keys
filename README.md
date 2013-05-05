# chef-keys

[![Build Status](https://travis-ci.org/cmur2/chef-keys.png)](https://travis-ci.org/cmur2/chef-keys)

## Description

Cookbook to distribute SSH public and private keys.

## Usage

Use `recipe[keys::default]` for copying the ssh keys to the designated users.

## Requirements

### Platform

Any *nix.

## Recipes

### default

Reads hash of user_name => config mappings from `node['keys']['users']` where the config is a hash of key_file_name => key_content mappings.

## License

chef-keys is licensed under the Apache License, Version 2.0. See LICENSE for more information.
