# Accessibility (a11y) Review Checklist

Use this checklist to verify that the application is fully accessible to users with visual, motor, or cognitive disabilities.

## 1. Screen Reader Compatibility
- [ ] All interactive icons, buttons, and custom touch areas have meaningful `Semantics(label: ...)` definitions.
- [ ] Purely decorative backgrounds, dividers, and graphics are wrapped in `Semantics(excludeSemantics: true)`.
- [ ] Tested with Android TalkBack and iOS VoiceOver to confirm logical screen reading order and clear pronunciation.

## 2. Touch & Interaction
- [ ] All tappable buttons, links, and icons have a minimum touch target size of 48x48 logical pixels.
- [ ] Input forms support proper keyboard action buttons (`next`, `done`) and autofill hints (`AutofillHints.email`).
- [ ] Custom dialogs and bottom sheets trap focus correctly and can be dismissed via standard escape/back gestures.

## 3. Visual Accessibility
- [ ] UI layouts respect OS-level dynamic font scaling without overflowing or clipping text (`TextScaler`).
- [ ] Text elements maintain a minimum color contrast ratio of 4.5:1 against their background (3:1 for large/bold text).
- [ ] Information is never conveyed by color distinction alone (error states include text explanations and icons).
- [ ] Animations and auto-scrolling banners check and respect `MediaQuery.of(context).disableAnimations`.
