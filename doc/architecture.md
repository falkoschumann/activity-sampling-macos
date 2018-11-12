# Application Activity Sampling

![Context diagram](context.png)

## Domain Design

### Dialog Activity Log

#### System clock ticks

*   Update elapsed time.
*   Update remaining time.
*   Check period ended.
*   If period ended, ask for current activity.

#### User logs activity

*   Show activity with period timestamp in dialog.
*   Write activity with period timestamp to disk.

## Flow Design

![Flow](flow-design.png)
