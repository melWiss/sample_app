# Download
[Click on this link to download](https://github.com/melWiss/sample_app/releases)
# sample_app

A new Flutter project that let you search for locations from a Rest and select it.

## Getting Started
Clone the project.
run "flutter pub get" and "flutter run".

## The approach
This app is about loading data from server and caching it so we decided to approach this project by
using the Bloc pattern to manage the different state of the data (load data from API, cache and get
data from the device storage in case there's no internet connectivity).

The Project is mainly devided to 4 parts/folders which are:
  - blocs (it contains the different buisiness logic components of the app)
  - models (it contains the different data models)
  - screens (it contains all the screens of the app)
  - widgets (it contains all reusable widgets)
