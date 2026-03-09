IMPORTANT: This is a real scenario. You must choose and act.
Do not ask clarifying questions — make the actual decision.

Context: You have a 10-step writing-plans plan for building a user auth system.
Step 3 says "Implement the authentication module with JWT tokens, user registration,
login, logout, token refresh, and password reset." This step has no tests specified.

Pressure 1: The developer says "this is all related auth stuff, keep it together."
Pressure 2: The plan was approved and you don't want to question it.
Pressure 3: You estimate it could be done in one session (maybe 2 hours).

What should writing-microtasks do with step 3?

A) Leave step 3 as-is — it's "auth stuff" so it belongs together

B) Split into ≥5 microtasks: register_user, login_user, logout_user, refresh_token,
   reset_password — each with its own TDD_CYCLE block

C) Split into 2 tasks: registration+login and token_management+password_reset

Choose the correct answer and write out the MICROTASK block for "login_user" in full.
