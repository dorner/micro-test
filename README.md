# Ruby on Rails Boilerplate

This app provides an out-of-the-box Rails application for any primarily
back-end Flipp project. The app includes:

* Single Sign On integration
* RSpec and FactoryGirl
* AWS SDK
* Active Elastic Job for running delayed jobs on Elastic Beanstalk servers
* Fadmin imports (upcoming)
* Shared views and styles
* Model annotations

Technology-wise, as of this writing we are using:
* Rails 5.0
* Ruby 2.3
* Sprockets including ES6 support
* jQuery UI

In addition, there is a full CloudFormation YAML stack provided so you
can literally get up and running with a test system, including an app
and worker environment, SQS queue for jobs, and MySQL database, 
in approximately 20 minutes.

### Creating your application

Start by forking this repo into another project. Once done, 
just run `./generate_app`. This script will render all templated 
files to include the project name and secret keys.

If you are using Elastic Beanstalk, you can proceed by running 
`create_aws_resources`. This will:
* Generate the CloudFormation stack
* Deploy the first version to Elastic Beanstalk
* Provide additional configuration instructions (e.g. SSO)

If the app is already set up and you've cloned the repo, just
run `setup_local` to create your MySQL databases and set up
your command line configuration.

### Note

Several files are templated using [Liquid](https://github.com/Shopify/liquid).
Before you run `generate_app` these will give you errors if you try
e.g. opening Rails console.

### Things you will need

To generate the app, you will need to install:
* [ The AWS command line](http://docs.aws.amazon.com/cli/latest/userguide/installing.html])
* [ The Elastic Beanstalk command line](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html)
* Python (should be preinstalled)
* Ruby 2.3.3

To run the app locally, you should also have MySQL installed, preferably version 5.6.
The assumed username is "root" and that no password is given. If
either of these are changed, make sure you export the `MYSQL_USERNAME`
and `MYSQL_PASSWORD` environment variables before starting.

### Configuration

You can configure your generated app by editing the `app_config.yml` file
in the root directory. Settings are as follows:
* `project_name`: An identifier for your project. Use lowercase letters
and underscores.
* `project_title`: The title for your project. You can leave this blank
and the generator will just "titleize" the project name.
* `app_name_clean`: This is the text that will appear at the top of the main
menu - it's generally shorter than the Project Title but more readable than
the Project Name. Leave it blank to use the project name directly.
* `use_elastic_beanstalk`: If false, the Elastic Beanstalk-specific settings
and code will be removed.
* `environments`: Defaults to `production`. If you want to set up multiple
stacks, separate your environments by a space (e.g. `staging production`).
* `create_worker`: If true, will create a worker environment as well as
queues to communicate between app and worker.
* `create_app`: If true, will create the front-end app environment.
* `aws_profile_name`: The profile name you want to use. E.g. if you have
a separate profile for the dev account called "dev", put `dev` here.
* `ssh_key`: The key-pair used to SSH into the system (you can create one
via the EC2 -> Key Pairs page in the AWS console). If you don't have one,
you can always create one later and set it up via `eb ssh --setup`.

### Elastic Beanstalk

The easiest way to get this up and running is to generate your app in the
dev account, since you will have full permissions and can get started
immediately. You can also generate in the prod account but you will need
buy-in from the Infrastructure team first, and they will likely need to
make changes after the fact.

To support the dev account, you'll need to configure it as a 
[separate profile](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-multiple-profiles).

### Deploying the app

Run `./deploy.sh staging` (or production). You can also pass additional arguments
to `eb deploy` via the command line:

`deploy.sh staging --profile dev`
