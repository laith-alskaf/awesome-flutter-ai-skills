# UX Psychology & Usability Heuristics

This document contains the psychological rules of UX that govern how interfaces should behave in a world-class Flutter application.

## 1. Fitts's Law (Touch Targets & Reachability)
> *The time to acquire a target is a function of the distance to and size of the target.*

- **Application:** Make primary buttons large and place them near the bottom of the screen (reachable by the thumb).
- **Rule:** Minimum touch target size is `48x48` logical pixels. Never put destructive actions (Delete) next to primary actions (Save).

## 2. Jakob's Law (Familiarity)
> *Users spend most of their time on other apps. They prefer your app to work the same way as all the other apps they already know.*

- **Application:** Don't reinvent standard UI patterns. Use bottom navigation bars for top-level routing, swipe-to-go-back gestures, and standard iconography (gear for settings, magnifying glass for search).

## 3. The Zeigarnik Effect (Progress Indicators)
> *People remember uncompleted or interrupted tasks better than completed tasks.*

- **Application:** Use visual progress bars or step indicators for onboarding or checkout flows. Give users a sense of completion (e.g., "Step 2 of 4").

## 4. Hick's Law (Cognitive Overload)
> *The time it takes to make a decision increases with the number and complexity of choices.*

- **Application (Progressive Disclosure):** Do not show a settings page with 20 toggles at once. Group them into categories. Use `ExpansionTile` or separate screens to hide advanced options until the user requests them.

## 5. Nielsen's Usability Heuristics (Mobile Adaptation)

1. **Visibility of System Status:** Always use Haptics (`HapticFeedback`) and Shimmers (Skeleton loaders) to let the user know the app is doing something. Never leave a frozen screen.
2. **Match Between System and Real World:** Speak the user's language. Use icons that map to real-world objects.
3. **User Control and Freedom:** Always provide a clear "Back" or "Cancel" button. If a user deletes an item, provide a `SnackBar` with an "Undo" action.
4. **Consistency and Standards:** Always use the Design System tokens (Colors, Typography). Do not use custom shades of blue if the theme dictates a specific primary color.
5. **Error Prevention:** Disable the "Submit" button if a form is invalid. Show validation errors *before* the user clicks submit.
6. **Recognition Rather Than Recall:** Use Autocomplete for text fields. Keep recently searched terms visible.
7. **Aesthetic and Minimalist Design:** Eliminate UI noise. Use white space (padding/margins) to group related elements instead of drawing harsh borders between everything.
8. **Help Users Recognize, Diagnose, and Recover from Errors:** Never show raw exception strings (`Exception: 404 Not Found`). Show an illustration and friendly text: "We couldn't find that item. Try refreshing."
