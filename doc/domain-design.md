# Application Activity Sampling

## Dialog Activity Log

### Interaction Enter Activity

*   Close demand dialog if open.
*   Log the entered activity as current activity.

### Interaction Show Progress

*   Display the elapsed and remaining time in current sampling period.

### Interaction Show Log

*   Display a log of last activities.

### Interaction Change Preferences

*   Show the _Preferences_ dialog.

## Dialog Demand

### Interaction Confirm current Activity

*   If no current activity set, open _Activity Log_ dialog.
*   Else log the last activity as current activity also.
*   Close demand dialog.

### Interaction Other Activity

*   Show the _Activity Log_ dialog.

## Dialog Preferences

### Interaction Sampling Rate

*   Adjust the sampling rate for the demand for the current activity.

### Interaction Close

*   Close the _Preferences_ dialog.
