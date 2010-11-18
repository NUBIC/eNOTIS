######
# This is not an executable script.  It selects and configures rvm for
# bcsec's CI process based on the RVM_RUBY environment variable.
#
# Use it by sourcing it:
#
#  . ci-env.sh
#
# Assumes that the create-on-use settings are set in your ~/.rvmrc:
#
#  rvm_install_on_use_flag=1
#  rvm_gemset_create_on_use_flag=1
#
# Hudson Build Execute Shell Commands:
#
# # RVM uses bash from the path
# PATH="/opt/local/bin:$PATH"
# source ci-env.sh
# export RAILS_ENV="hudson"
# rake -f init.rakefile --trace
# bundle exec rake log:clear
# bundle exec rake db:migrate --trace
# rake hudson:all --trace
#

set +x
echo ". ~/.rvm/scripts/rvm"
. ~/.rvm/scripts/rvm
set -x

RVM_RUBY=ree-1.8.7-2010.01
GEMSET=enotis

if [ -z "$RVM_RUBY" ]; then
    echo "Could not map env (RVM_RUBY=\"${RVM_RUBY}\") to an RVM version.";
    shopt -q login_shell
    if [ $? -eq 0 ]; then
        echo "This means you are still using the previously selected RVM ruby."
        echo "Probably not what you want -- aborting."
        # don't exit an interactive shell
        return;
    else
        exit 1;
    fi
fi

echo "Switching to ${RVM_RUBY}@${GEMSET}"
set +xe
rvm use "${RVM_RUBY}@${GEMSET}"
if [ $? -ne 0 ]; then
    echo "Switch failed"
    exit 2;
fi
set -xe
ruby -v

set +e
gem list -i rake
if [ $? -ne 0 ]; then
    echo "Installing rake since it is not available"
    gem install rake
fi
set -e
