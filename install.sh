# Install Homebrew if not in your Mac
if ! type brew > /dev/null 2>&1; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

sh system.sh
sh app.sh
