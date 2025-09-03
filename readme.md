# Action for [ideckia](https://ideckia.github.io/): health-reminder

## Description

Healthy reminders


Idea taken from https://github.com/Jorkoh/Stream-Deck-Health-Reminders

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| interval | number | Interval in minutes | false | 30 | null |
| cron_expression | text | (if you don't know what cron is, ignore this) Cron expression to program reminders. Has priority over interval. | false | null | null |

## On single click

Updates the information in the item

## On long press

Reset the timer

## Localizations

The localizations are stored in `loc` directory. A JSON for each locale.

## Test the action

There is a script called `test_action.js` to test the new action. Set the `props` variable in the script with the properties you want and run this command:

```
node test_action.js
```

## Example in layout file

```json
{
    "text": "health-reminder example",
    "bgColor": "00ff00",
    "actions": [
        {
            "name": "health-reminder",
            "props": {
                "interval": 30,
                "cron_expression": null
            }
        }
    ]
}
```
