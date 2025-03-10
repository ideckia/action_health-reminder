# Action for [ideckia](https://ideckia.github.io/): health-reminder

## Description

Healthy reminders

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| interval | number | Interval in minutes | false | 30 | null |

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
                "interval": 30
            }
        }
    ]
}
```
