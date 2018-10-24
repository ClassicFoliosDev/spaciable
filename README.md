# README

## Setup

- Install the ruby version defined in the `.ruby-version` file
- Make sure you have bundler installed `gem install bundler`
- Install PostgreSQL: either with `brew install postgresql` or download the [Postgres.app](http://postgresapp.com/)
- Clone the project: `git clone https://github.com/Classic-Folios/hoozzi.git`
- `cd` into the project directory: `cd hoozzi`
- Setup the project: `bin/setup`

To generate thumbnails of PDFs make sure you have imagemagick 6 with ghostscript installed, imagemagick 7 does not work with RMagick:

```
$ brew tap homebrew/versions
$ brew install imagemagick@6 --with-ghostscript
$ echo 'export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"' >> ~/.bash_profile
```
If you are having problems with imagemagick, then getting graphicsmagick to work can be easier:

```
# gs is the ghostscript package
brew install gs graphicsmagick
```

## Generate admin and homeowner accounts

`$ rake db:seed`

## Running the application

To see emails sent locally you will need to start up a delayed job queue using:

```
$ bin/delayed_job start
```

You can stop the queue using:

```
$ bin/delayed_job stop
```

To run delayed job in the foreground, for inspection of the log, you can use the rake task instead of the `bin/delayed_job` script:

```
$ rails jobs:work
```

## Users

The default admin user's credentials are:

```
email: admin@alliants.com
password: 12345678
```

For development mode only, the default homeowner user's credentials are:

```
email: homeowner@alliants.com
password: 12345678
```

This user is added when you run `bin/setup`.

In order to send mails to mailchimp from a dev environment, you will need to configure an
environment variable with the mailchimp API key. This can be found in any of the AWS environments,
and in the mailchimp profile under Extras.

```
MAILCHIMP_KEY=64-bit-key
```

## Running the tests

`$ brew install phantomjs`

`$ bundle exec bin/test`

The CI runs `bin/test` which does use the standard test frameworks CLI runners.
Consequently running `$ cucumber` locally will run slightly different to the CI.

In order to run individual parts of the suite:
```
$ bundle exec bin/test rubocop
$ bundle exec bin/test rspec
$ bundle exec bin/test cucumber
```

### Testing javascript

Phantom js and poltergeist have been integrated, but they do have some quirks, and debugging is tricky.
You need to install Phantom js to run tests locally: http://phantomjs.org

#### Open a debug view:

When executing javascript, there will be a lag in performing js activities, so you may need a sleep before you use
debug. For example:
  * sleep(0.5)
  * save_and_open_page and/or
  * save_and_open_screenshot

Several convenience methods have been added which encapsulate these:

- `html_debug`: this will `sleep` and then run `save_and_open_page`
- `screenshot`: this will `sleep` and then run `save_and_open_screenshot`

#### Inspector Mode

To use the built in debugging driver for poltergeist invoke cucumber with the environment variable `DEBUG=true`. This will open up a web inspector in your browser where you can browse the current DOM, but I am yet to find this better than `html_debug`, as it is slower and continuing the process after debugging often doesn't work.

If you get unique validation errors when you try and run the tests again it means that the process did not run the after hooks and reset the test database. You can do this manually using this rake task:

```
$ rails db:test:prepare
```

#### Debug on command line

It's possible to print output to the command line, but generally doesn't provide useful content. You can try this:
  * btn = find("[name=mybtn]");
  * puts(btn.native)
But if poltergeist is involved, the output is unlikely to be helpful. Please update this section if you find a 
way to debug poltergeist contents, otherwise, the best known approach is the debug view above

## Component Styleguide

The [`livingstyleguide`](https://livingstyleguide.org/) gem is used to generate a component styleguide from the `.lsg` files in `/assets/stylesheets/`. To view the styleguide, run `rake styleguide:compile`, ensure the rails server is running and visit http://localhost:3000/styleguide.html

### Live compilation

When writing and documenting SCSS styles, you can use `guard` to watch for changes and automatically compile the styleguide.

`bundle exec guard`

Guard watches `.scss` and `.lsg` files, and triggers when new files are created, files are deleted and existing files are modified. When it triggers, the styleguide will be compiled and SCSS will be validated (using `guard sass`).

To stop guard type `exit`.

## Automated Deployment

### Deploy to QA Environment

Make sure the QA environment is clear for you to use first, ask in slack.

Run `bin/qa_check` and your branch will be pushed up to the `qa` branch (`$ git push origin your-branch-name:qa` essentially).

Codeship will run the tests on this branch and then deploy your branch to the qa environment for you. You can access the QA environment at: [hoozzi-qa.alliants.net](http://hoozzi-qa.alliants.net).

### Deploy to Staging

Before deploying to production, the changes should be approved by the product owner first. The staging environment is where changes awaiting approval can be demoed to the product owner.

Any commits merged into the `master` branch will be deployed to the staging environment by codeship, once the automated tests have passed.

The staging environment can be accessed at: [hoozzi.alliants.net](hoozzi.alliants.net).


### Deploy to Production Environment

To deploy to **production** you need to tag a commit with a release.

First get a list of existing tags:

```
$ git fetch --tags
$ git tag --list
```

Set your git working tree to the commit you want to be deployed:

```
$ git checkout master
$ git reset --hard origin/master
```

Then add a tag for the next incremented release:

```
$ git checkout master
$ git tag release-0.2
$ git push --tags
```

Codeship will run the tests for this commit and deploy this code to the production environment if successful.
The alternative url for hoozzi production is: [hoozzi-prod.alliants.net](http://hoozzi-prod.alliants.net).

## Manual Deployment

### Setup your environment to deploy

Download the elastic beanstalk cli tool:

```
$ brew install awsebcli
```

Change into the projects directory and run the init script for the `eb` tool you just installed:

```
$ cd hoozzi
$ eb init
# follow the prompts to choose default env from the list
# answer no to using CodeCommit, we have Github :)
```

Obtain the AWS access key and id for deployment from the ops team, then run the following command and fill in the prompts:

```
$ aws configure
# choose 'eu-west-1' for the default region
```

### Perform a deployment

Choose the environment you wish to deploy too:

```
$ eb use staging
```

The `eb` tool will deploy the code that is checked out within your local directory, so make sure to update with the remote repository before deploying:

```
$ git fetch
$ git checkout master
$ git reset --hard origin/master
```

To run the actual deployment use:

```
$ eb deploy
```

This should take a couple of minutes. The process the deployment roughly follows is:

- zips up the local code that has been commit to git
- sends the archive to an S3 bucket
- creates a new EC2 instance based on our platform settings
- unzips the archived code onto the new EC2 instance
- runs a series of pre deployment hooks to configure the application
- starts up the rails application
- runs a series of post deployment hooks
- switches the load balancer to point traffic to the new EC2 instance
- turns the old EC2 instance off, but keeps it around incase we want to revert back to it

## Search deploy

When you deploy the pg_search feature, any content added after this point will be included in search results. But 
content added before the search feature will be missing from the search index in pg_search

To include earlier content, run a rake task. You will need to repeat for each model type 
which you want to be search-enabled, here's the syntax.

```bundle exec bin/rake pg_search:multisearch:rebuild\[Appliance\]```

## Background Jobs

Delayed job is configured with active record, it uses a database and workers to handle many jobs at the same time in the same process. All background jobs are queued up in the delayed_job table, waiting for workers to pick them up and process them.

There are several named queues, the most important, carrierwave, is defined in the `config/initializers/carrierwave_backgrounder.rb` file.

For more information see 
* https://github.com/collectiveidea/delayed_job_active_record
* https://github.com/collectiveidea/delayed_job/wiki

## Reset terms and conditions

To reset the terms and conditions database contents, run the following rake task:

```bundle exec bin/rake ts_and_cs:reset```

*Warning* 
This will reset the status for all residents in the database to "false" for ts_and-cs_accepted
