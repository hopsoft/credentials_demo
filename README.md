# Credentials Demo

## What

Demo of environment aware Rails encrypted credentials with environment variable override.

## Why

1. Simplifies configuration management
1. Centralizes application secrets
1. Reduces the number of managed environment variables... often limited to one (`RAILS_MASTER_KEY`)
1. Eliminates wasted developer time due to missing environment variables
1. Reduces gem dependencies... [dotenv](https://github.com/bkeepers/dotenv), etc.
1. Preserves productivity by exposing configuraiton via the environment `ENV`
1. Retains flexibility by allowing the environment (`ENV`) to override

## How

Here's the [TL;DR](https://github.com/hopsoft/credentials_demo/blob/main/config/application.rb#L11-L16) for the impatient folks.

1. Edit the Rails encrypted credentials file.

    ```sh
    bin/rails credentials:edit
    ```

    ```yaml
    default: &default
      aws_access_key_id: AKIAIOSFODNN7EXAMPLE
      aws_region: us-east-1
      aws_secret_access_key: b1e4c2d8f9a7g5i3h2j4k1l6m8n0o9p5q7r3s1t2u6v8w0x9y4z2

    development:
      <<: *default
      database: db/databases/development.sqlite3
      secret_key_base: 31461f5d38cc7f2e919ea18e9a390bd3558a31be2e5d8e79b9c40ae7a91a5990768da5c8baa2521462c366f5568c4d58b843f92ea5eda71d9bc9c8a8b0c96435

    test:
      <<: *default
      database: db/databases/test.sqlite3
      secret_key_base: 852d4a5f4796699b4204c776c6b7f2934fd2f5424ac9d2f8f15d6bf9a0efc1f4bc5fd6b44fd1b0774de7168a0990d76ae6c3229370414db7b7d66830b2f74491

    production:
      <<: *default
      aws_access_key_id: AKIA5VXCTQ99GEXAMPLE
      aws_secret_access_key: 3a9d8a2b5c4e1f7g6h2i5j1k3l4m7n8o9p0q1r2s3t4u5v6w7x8y9z0
      database: db/databases/production.sqlite3
      secret_key_base: b05157ed1f089563a5c754d6219b6a4fdf7c521d0e970ddc15cdd9a1bec58fa251191d50d1b8500987a2589a98afa20f27b964e2eefed9dbc574036880af34e0
    ```

2. The application merges the encrypted credentials into the environment `ENV` on boot

    ```ruby
    creds = credentials[Rails.env.to_sym]
      .with_indifferent_access
      .transform_keys(&:upcase)
      .transform_values(&:to_s)

    ENV.merge! creds.merge(ENV)
    ```

3. Access the configuration via `ENV`

    ```sh
    bin/rails console --environment development
    ```

    ```ruby
    ENV.fetch "DATABASE" # => db/databases/development.sqlite3
    ```

    ---

    ```sh
    bin/rails console --environment test
    ```

    ```ruby
    ENV.fetch "DATABASE" # => db/databases/test.sqlite3
    ```

    ---

    ```sh
    bin/rails console --environment production
    ```

    ```ruby
    ENV.fetch "DATABASE" # => db/databases/production.sqlite3
    ```

    ---

    Example of environment variable override.

    ```sh
    DATABASE=db/databases/foo.sqlite3 bin/rails console --environment production
    ```

    ```ruby
    ENV.fetch "DATABASE" # => db/databases/foo.sqlite3
    ```

## Next Steps

Consider combining this technique with environment specific credentials if you'd like  to hide specific environment configurations from developers.

```sh
bin/rails credentials:help
bin/rails credentials:edit --environment production
```
