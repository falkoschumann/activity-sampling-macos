# User Acceptance Tests

## Scenario: User logs first activity 

*   Given the period duration is one minute
*   And there is no current activity
*   When the period ends
*   And the user logs activity "Lorem ipsum"
*   Then the dialog Activity Log shows the current date
*   And the dialog Activity Log shows the current time and activity "Lorem ipsum"
*   And the input of dialog Activity Log is disabled
*   And the log file begins with table header
*   And the log file ends with a row containing current timestamp, period duration and activiyt "Lorem ipsum"

## Scenario: User logs another activity

*   Given the period duration is one minute
*   And an activity was logged
*   When the period ends
*   And the user logs activity "Lorem ipsum"
*   Then the dialog Activity Log shows the current time and activity "Lorem ipsum"
*   And the input of dialog Activity Log is disabled
*   And the log file ends with a row containing current timestamp, period duration and activiyt "Lorem ipsum"

## Scenario: User logs same activity

*   Given the period duration is one minute
*   And the activity "Lorem ipsum" was logged
*   When the period ends
*   And the user logs same activity
*   Then the dialog Activity Log shows the current time and activity "Lorem ipsum"
*   And the input of dialog Activity Log is disabled
*   And the log file ends with a row containing current timestamp, period duration and activiyt "Lorem ipsum"
