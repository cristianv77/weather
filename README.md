# Weather Application

A Ruby on Rails web application that provides real-time weather information and forecasts using the OpenWeather API. Users can search for weather data by city/state or by geolocation coordinates.

## Tech Stack

- **Ruby**: 3.4.3
- **Rails**: 7.2.2

## Installation

1. **Install Ruby dependencies**
   ```bash
   bundle install
   ```

3. **Install JavaScript dependencies**
   ```bash
   yarn install
   ```

4. **Set up the database**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

## Running the Application

Start the development server with:
```bash
bin/dev
```

Alternatively, you can run them separately for better debugging:
```bash
# Start Rails server
bin/rails server

# Start Tailwind CSS watcher (in another terminal)
bin/rails tailwindcss:watch
```

The application will be available at `http://localhost:3000`

## API Configuration

This application requires an OpenWeather API key. To get one:

1. Visit [OpenWeather API](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key
4. Add the key to your `.env` file
