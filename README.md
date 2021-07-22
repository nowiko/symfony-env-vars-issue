## Requirements for local environment
* PHP >= 7.4
* Composer
* Docker
* Docker Compose

## Local installation

1) Clone repository
```bash
    git clone git@github.com:nowiko/symfony-env-vars-issue.git
```

2) Create `.env.local` file (copy `.env`) and add actual values for following groups of environment variables - `MAILER_*`, `AWS_`, and run:
```bash
composer dump-env
```

3) Install project dependencies via [Composer](https://getcomposer.org/download/):
```bash
    composer install
```

4) Run following command to build images and start containers:
```bash
    docker-compose up -d
```

6) To verify that everything works as expected, open [http://localhost:8080/api/health-check](http://localhost:8080/api/health-check)
