# 🦊 TestPokemonTask
A simple application to view Pokemons. This application displays a list of Pokemon and when you navigate, detailed information about the pokemon appears. The application is written using MVP.

## 📲 Now let's see how this application works:

After downloading the application, we get to the start screen (by the way, the launch screen is also present 😉). This is how start screen looks like. There are 2 buttons on it, for online and offline mode. Buttons are activated depending on an Internet connection (monitored through the Network framework).
Screenshot of the start screen below. In this case there is an internet connection.

<img src="https://raw.githubusercontent.com/Scooterminsk/TestPokemonTask/main/Screenshots/MainScreen.png" alt="Start screen" style="height: 800px;"/>

<br />

By clicking on the active button, we get to the screen with the list of Pokemon, which supports pagination (Pokemon are loaded by 10, depending on the scroll). Also, at the first online start, the list of Pokemon is saved in Realm.

<img src="https://raw.githubusercontent.com/Scooterminsk/TestPokemonTask/main/Screenshots/PokemonList.png" alt="Pokemon list" style="height: 800px;"/>

<br />

After clicking on a table view cell, the user is taken to a screen with detailed information about the Pokemon. All information is also stored in Realm. The height and weight of the Pokemon are given in values that correspond to the condition of the task.

<img src="https://raw.githubusercontent.com/Scooterminsk/TestPokemonTask/main/Screenshots/PokemonDetails.png" alt="Pokemon details" style="height: 800px;"/>

<br />

Internet connection is checked on the start screen. If it is missing, then an alert appears that warns that the application will be offline. The user can continue in offline mode, the button is activated.

<body>
  <p>
    <img src="https://raw.githubusercontent.com/Scooterminsk/TestPokemonTask/main/Screenshots/NoNetworkCase.png" alt="No network case" style="height: 800px;">
    <img src="https://raw.githubusercontent.com/Scooterminsk/TestPokemonTask/main/Screenshots/OfflineMode.png" alt="Offline mode" style="height: 800px;">
  </p>
 </body>

If the user has already entered the application in online mode, then he has some data loaded into Realm. Anything already uploaded will be shown to the user. If some data is not loaded, then he will see a picture as in the example below.

<img src="https://raw.githubusercontent.com/Scooterminsk/TestPokemonTask/main/Screenshots/PokemonNotSaved.png" alt="Pokemon not saved" style="height: 800px;"/>

<br />

## 🎉 Thanks for reading the documentation, now you can check the project files.
