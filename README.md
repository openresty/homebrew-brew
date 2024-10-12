# NGINX Homebrew Tap

This tap is designed specifically for a custom build of NGINX with more module options.

## How do I install these formule (NGINX Modules)?
Once the tap is installed, you can install `nginx-full`
with optional [additional modules](https://brew.sh/homebrew-nginx/#modules):

```bash
brew tap openresty/brew
brew install openresty
```

There is also a debug version of openresty for hard-core developers:

```bash
brew install openresty-debug
```

If you already installed OpenResty from homebrew/nginx, please run the following command first:

```bash
brew untap homebrew/nginx
```

For a list of available configuration options run:

```bash
brew options openresty
```

## What about conflicts?

You are free to install this version alongside a current install of NGINX from `Homebrew/homebrew` if you wish. However, they cannot be linked at the same time. To switch between them use brew's built in linking system.

```
brew unlink nginx
brew link openresty
```

## Where is the configuration file for openresty?

You can find the configuration files for openresty under `$HOMEBREW_PREFIX/etc/openresty/` (The default value of `$HOMEBREW_PREFIX` is `/usr/local` and you can check the value of `$HOMEBREW_PREFIX` with `brew --config` command).

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://github.com/Homebrew/brew/blob/master/docs/README.md).

## Contributing
Please see the [contributing guide](https://github.com/openresty/homebrew-brew/blob/master/.github/CONTRIBUTING.md).

## How to submit a new formula
* Fork this repository on GitHub.
* Clone to your Mac.
* Read and look at the other formule here.
* In your locally cloned `homebrew-nginx` repo, create a new branch: `git checkout --branch my_new_formula`
* Write/edit your formula (ruby file). Check [Homebrew's documentation](https://github.com/Homebrew/brew/blob/master/docs/README.md) for details.
* Test it locally! `brew install ./my-new-formula.rb`. Does it install? Note, `./<formula>.rb` will target the local file.
* `git push --set-upstream origin my-new-formula` to get it into your GitHub fork as a new branch.
* If you have to change something, add a commit and `git push`.
* On GitHub, select your new branch and then click the "Pull Request" button.

# Development

## update openssl3

Run the following command to update the openssl3 and test the building.

```shell
cd Formula
./update-ssl3 3.0.15
brew install --build-from-source ./openresty-openssl3.rb
```

## update openresty

Run the following command to update the openresty and test the building.

```shell
cd Formula
./update-or 1.27.1.1
#change the openssl3 dependency if needed.
sed -i '' "s#openresty/brew/openresty-openssl3#$PWD/openresty-openssl3.rb#g" openresty.rb
brew install --build-from-source ./openresty.rb
```
