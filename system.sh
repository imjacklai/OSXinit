source config.sh

# Integrates Homebrew formulae with MacOS X's launchctl manager
# ---------------------------------------------------------------
brew tap homebrew/services


# Essential
# ---------------------------------------------------------------
brew install openssl
brew install wget
brew install git

git config --global user.name $git_username
git config --global user.email $git_email
git config --global alias.co checkout
git config --global alias.st status
git config --global alias.br branch


# Use Zsh as default shell
# ---------------------------------------------------------------
brew install zsh

# Add Zsh path to /etc/shells
if ! grep -q "/usr/local/bin/zsh" "/etc/shells"; then
  sudo sh -c "echo /usr/local/bin/zsh >> /etc/shells"
fi

# Install oh-my-zsh and change shell to Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Download Zsh theme - Spaceship
THEME_FILE="$HOME/.oh-my-zsh/themes/spaceship.zsh-theme"
REMOTE_FILE="https://raw.githubusercontent.com/denysdovhan/spaceship-zsh-theme/master/spaceship.zsh-theme"
if [ ! -f "$THEME_FILE" ]; then
  curl -o $THEME_FILE $REMOTE_FILE
fi

# Replace current theme to Spaceship
sed -i "" 's/ZSH_THEME=".*"/ZSH_THEME="spaceship"/' "$HOME/.zshrc"

# [Spaceship] Disable to show Node version on prompt
if ! grep -q "SPACESHIP_NVM_SHOW=false" "$HOME/.zshrc"; then
  echo "SPACESHIP_NVM_SHOW=false" >> "$HOME/.zshrc"
fi

# [Spaceship] Disable to show Ruby version on prompt
if ! grep -q "SPACESHIP_RUBY_SHOW=false" "$HOME/.zshrc"; then
  echo "SPACESHIP_RUBY_SHOW=false" >> "$HOME/.zshrc"
fi


# Setup Ruby environment
# ---------------------------------------------------------------
brew install ruby-build
brew install rbenv

if ! grep -q 'eval "$(rbenv init -)"' "$HOME/.zshrc"; then
  echo 'eval "$(rbenv init -)"' >> "$HOME/.zshrc"
  eval "$(rbenv init -)"
fi

# Install Ruby with specific versions
for version in "${ruby_versions[@]}"
do
  if ! rbenv versions | grep -q "$version"; then
    rbenv install "$version"
  fi
done

# Set ruby version of global to latest version
rbenv global "${ruby_versions[@]: -1}"

if [ ! -f "$HOME/.gemrc" ]; then
  touch "$HOME/.gemrc"
  echo "gem: --no-ri --no-rdoc" >> "$HOME/.gemrc"
fi

gem update --system

if ! gem list bundler --installed > /dev/null; then
  gem install bundler
  rbenv rehash
fi


# Setup Node environment
# ---------------------------------------------------------------
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
fi


# Configure services
# ---------------------------------------------------------------
brew install mysql
brew services start mysql

brew install redis
brew services start redis

brew install nginx
brew services start nginx


# Others
# ---------------------------------------------------------------
brew install imagemagick
brew install the_silver_searcher
