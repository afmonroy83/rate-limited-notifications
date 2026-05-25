# Rails Notifications App

This is a notifications system built in Rails that includes a background job queue service using **Sidekiq** and **Redis**. The system allows sending different types of notifications to users, applying rate limits to avoid overwhelming recipients with too many emails.

## Technologies Used

- **Rails** 7.x
- **PostgreSQL** (with PostGIS support)
- **Redis** (for managing Sidekiq queues)
- **Sidekiq** (for background job processing)
- **Docker** (for development environment containerization)

## Project Setup

### Prerequisites

Make sure you have the following installed on your machine:

- **Docker** and **Docker Compose**

### Steps to Run the Project

1. **Clone the repository**

   Clone this repository to your local machine:

   ```bash
   git clone https://github.com/afmonroy83/rate-limited-notifications.git
   cd rate-limited-notifications
   ```

2. **Build and start the containers with Docker Compose**

   Run the following command to build and start all services (database, Redis, web, and Sidekiq):

   ```bash
   docker-compose up --build
   ```

   This will start the Rails application, PostgreSQL database, Redis server, and the Sidekiq service.

3. **Set up the database**

   Open a new terminal and run the migrations for the database:

   ```bash
   docker compose exec web bash
   bundle exec rails db:migrate
   ```

   This will create and migrate the database inside the Docker container.

4. **Start Sidekiq**

   Open a new terminal to start Sidekiq:

   ```bash
   docker compose exec web bash
   bundle exec rails sidekiq
   ```

5. **Access the application**

   The application will be available in your browser at `http://localhost:3000` by running the following command:

   ```bash
   docker compose exec web bash
   bundle exec rails server --port=3000 --binding="0.0.0.0"
   ```

6. **Testing Tools**

   - Send a **status** notification:
     ```bash
     curl -X POST http://localhost:3000/notifications \
       -H "Content-Type: application/json" \
       -d '{"type":"status", "user_id":"user@example.com", "message":"account status"}'
     ```

   - Send a **news** notification:
     ```bash
     curl -X POST http://localhost:3000/notifications \
       -H "Content-Type: application/json" \
       -d '{"type":"news", "user_id":"user@example.com", "message":"you have news!"}'
     ```

   - Send a **marketing** notification:
     ```bash
     curl -X POST http://localhost:3000/notifications \
       -H "Content-Type: application/json" \
       -d '{"type":"marketing", "user_id":"user@example.com", "message":"the clickbait is here!"}'
     ```

   - Example of an invalid request:
     ```bash
     curl -X POST http://localhost:3000/notifications \
       -H "Content-Type: application/json" \
       -d '{"notification": {"type": "invalid_type", "user_id": "user@example.com", "message": "Test message"}}'
     ```

## Services

The project includes the following main services:

- **Web**: Rails application that handles notifications.
- **Sidekiq**: Background job processor for managing notification queues.
- **Redis**: In-memory data store that Sidekiq uses to manage queues.
- **PostgreSQL**: Relational database that stores the application data.

## Sidekiq Dashboard

To monitor queued Sidekiq jobs, you can access the Sidekiq dashboard at `http://localhost:3000/sidekiq`.

## Environment Variables

The following environment variables are required to configure the connection to services:

- `DB_USERNAME`: Database username (default: `postgres`).
- `DB_PASSWORD`: Database password (default: `12345`).
- `DB_NAME`: Database name (default: `notifications`).
- `DB_HOST`: Database host (default: `db`).
- `REDIS_SERVER`: Redis server URL (default: `redis://redis:6379`).

These variables are already configured in the `docker-compose.yml` file.

## Running Tests

To run the project tests, use the following command inside the web container:

1. Open a new terminal.
2. Run the following command to execute the tests:

   ```bash
   docker compose exec web bash
   bundle exec rspec
   ```

This will run all unit and integration tests configured for the project. The tests are written using the RSpec framework.

### Migrate the Test Database

Make sure the test database is properly set up before running the tests:

```bash
docker compose exec web bash
bundle exec rails db:migrate
```

## Common Issues

- **Sidekiq won't start**: Make sure Redis is running correctly. Check the Redis container with `docker-compose ps`.
- **Error connecting to the database**: Verify that the database environment variables in the `docker-compose.yml` file match your project configuration.
