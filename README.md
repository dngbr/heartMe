# heartMe

## Description

heartMe is a profile sharing application built with Ruby on Rails that allows users to create and share their profiles with others through unique URLs and QR codes. The application features user authentication with Devise, profile management with customizable profile pictures and background images, and an innovative sharing system using UUIDs.

Key features include:
- User authentication with Devise
- Profile creation and management
- Profile picture and background image upload
- Profile sharing via unique URLs
- QR code generation for easy profile sharing
- Mobile-friendly interface with Bootstrap styling

## Installation

### Prerequisites

- Ruby 3.3.0
- PostgreSQL
- Node.js and Yarn
- ImageMagick (for image processing)

### Local Setup

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/heartme.git
   cd heartme
   ```

2. Install dependencies
   ```bash
   bundle install
   yarn install
   ```

3. Database setup
   ```bash
   # Create the PostgreSQL database
   rails db:create
   
   # Run migrations
   rails db:migrate
   
   # Enable pgcrypto extension for UUID support
   rails db:execute "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
   ```

4. Start the Rails server
   ```bash
   rails server
   ```

5. Visit `http://localhost:3000` in your browser

## Deployment to Heroku

1. Create a Heroku account and install the Heroku CLI

2. Create a new Heroku app
   ```bash
   heroku create
   ```

3. Set up Amazon S3 for file storage
   - Create an S3 bucket
   - Create an IAM user with AmazonS3FullAccess policy
   - Set the required environment variables:
     ```bash
     heroku config:set AWS_ACCESS_KEY_ID=your_access_key
     heroku config:set AWS_SECRET_ACCESS_KEY=your_secret_key
     heroku config:set AWS_REGION=your_region
     heroku config:set AWS_BUCKET=your_bucket_name
     heroku config:set HEROKU_APP_NAME=your-app-name.herokuapp.com
     ```

4. Deploy the application
   ```bash
   git push heroku main
   ```

5. Run database migrations
   ```bash
   heroku run rails db:migrate
   ```

6. Enable pgcrypto extension
   ```bash
   heroku pg:psql
   CREATE EXTENSION IF NOT EXISTS pgcrypto;
   \q
   ```

7. Visit your Heroku app URL to use the application
