![BUNNY_INVASION](https://github.com/CaseIRL/fivem_bunny_invasion/assets/90377400/5756fe08-0c91-4442-995d-f74918970d02)

# FiveM Bunny Invasion Easter Event

### Preview

**[YouTube](https://www.youtube.com/watch?v=-jkYVcAiflw)**

### Overview

So everyone else is making easter egg hunts.. boring...
Have hordes of bunnies invade your city instead!

This is just a simple but engaging event for your players to add an extra layer of fun this easter.
Users with admin permissions can trigger a command in order to start an invasion.
Players can then opt in or out of the event.
For those that opt in they have to catch as many bunnies as they can within the time limite in order to win. 

Enjoy!

### Instructions

1. Adding the resource to your server

- Download the repo and add the resource into your server files
- Add `ensure bunny_invasion` to your server.cfg

2. Adding command permissions

- Add the following ace command perms into your server.cfg to allow admins to use the start event command

```
# Bunny invasion command usage
add_ace group.admin command.bunny_invasion:start allow
```

3. Starting the resource

- Press F8 and type `refresh; ensure bunny_invasion` and the resource will be ready
- Or restart your server either works

4. Starting an event

- To start the event an admin can type the following command

```
/bunny_invasion:start_event
```

### Customisation

The resource does not include any predefined language configs and I do not plan to add any.
If you want to change the language used you will have to take a look through the code and do this yourself. 

### Support

Support is not provided for this resource, it is free and open source.
Any framework specific modifications you wish to make you will have to do yourself.

Please do not join the BOII | Development discord asking for support, this will be denied.
