# Wizard Points

Wizard Points is a simple web app (optimized for mobile usage) that allows you to keep track of your points in the card game [Wizard](https://en.wikipedia.org/wiki/Wizard_(card_game)). 

Visit the [website](https://wizardpoints.app/#/) ([wizardpoints.app](https://wizardpoints.app/#/)) to get started.

## Features

- Up to 6 players
- Keep track of dealer and player order
- Adjustable settings
  - Personalization
  - Game rules
- Intuitive and simple UI
- Progressive Web App (PWA)

## Screenshots

<img src="images/players.png"
     alt="Player screen"
     width=330px
     style="float: left; margin: 5px;"/>
<img src="images/trick_prediction.png"
     alt="Predict trick count screen"
     width=330px
     style="float: left; margin: 5px;"/>
<img src="images/trick_selector.png"
     alt="Trick result selector screen"
     width=330px
     style="float: left; margin: 5px;"/>
<img src="images/new_round.png"
     alt="New round screen"
     width=330px
     style="float: left; margin: 5px;"/>
<img src="images/winner.png"
     alt="Winner screen"
     width=330px
     style="float: left; margin: 5px;"/>
<img src="images/settings.png"
     alt="Settings screen"
     width=330px
     style="float: left; margin: 5px;"/>

<div style="clear:both;"></div>

## Contributing

### GitHub

- Create a fork of the repository
- Clone the forked repository
- Create a new branch
- Make your changes
- Push your changes to your forked repository
- Create a pull request and describe your changes

### Flutter

- Install the [Flutter SDK](https://flutter.dev/docs/get-started/install).
- Check your Flutter installation

    ```bash
    flutter doctor
    ```

- Switch to the `stable` channel

    ```bash
    flutter channel stable
    flutter upgrade
    ```

- Install the dependencies

    ```bash
    flutter pub get
    ```

- Run the app

    ```bash
    flutter run [-d Chrome]
    ```

## Deployment

- Build the app using CanvasKit in release mode

    ```bash
    flutter build web --web-renderer canvaskit --release
    ```

- Deploy the app to Firebase

    ```bash
    firebase deploy
    ```
