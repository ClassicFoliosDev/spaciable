# README

## Setup

- Install the ruby version defined in the `.ruby-version` file
- Make sure you have bundler installed `gem install bundler`
- Install PostgreSQL: either with `brew install postgresql` or download the [Postgres.app](http://postgresapp.com/)
- Clone the project: `git clone https://github.com/Alliants/hoozzi.git`
- `cd` into the project directory: `cd hoozzi`
- Setup the project: `bin/setup`

## Running the application

`$ rails s`

The default admin user's credentials are:

```
email: admin@alliants.com
password: 12345678
```

This user is added when you run `bin/setup`.

## Running the tests

`$ bundle exec bin/test`

The CI runs `bin/test` which does use the standard test frameworks CLI runners.
Consequently running `$ cucumber` locally will run slightly different to the CI.

In order to run individual parts of the suite:
```
$ bundle exec bin/test rubocop
$ bundle exec bin/test rspec
$ bundle exec bin/test cucumber
```

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

Firstget a list of existing tags:

```
$ git fetch --tags
$ git tag --list
```

Set your git working tree to the commit you want to be deployed:

```
$ git checkout master
$ git reset -hard origin/master
```

Then add a tag for the next incremented release:

```
$ git checkout master
$ git tag 'release-0.2'
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
