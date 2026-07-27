# Nextern

## Project Vision

Nextern is a mobile application designed to provide learners with easy access to learning programs and internships while giving administrators tools to manage programs, monitor learner progress, review assignments and enrolment requests, publish announcements, and respond to feedback through a simple and user-friendly interface.

📄 For full project details, see our Week 3 documentation: [Nextern_Week_3_Development_Documentation.pdf](https://github.com/Jonathan-Go4th/Project-Nextern/blob/main/Nextern_Week_3_Development_Documentation.pdf)

🎥 Watch the [Demo Video](https://drive.google.com/file/d/1h6qsRaYFGqBf4dTSosTcI3IorAMZbxYi/view)

🎨 View our [Figma Wireframe (Updated)](https://www.figma.com/design/zFOUI2k38kZSWLhMXAM1sV/Nextern-App?node-id=92-55&t=Xy7SYgtqdB2bLa33-0)

🗃️ See our project archive [App Proposal Document](https://github.com/Jonathan-Go4th/Project-Nextern/blob/main/Nextern%20-%20App%20Proposal.pdf);  [Week 2 Deliverables](https://github.com/Jonathan-Go4th/Project-Nextern/blob/main/Nextern%20-%20Deliverables%20Week%202.pdf);  [App Demo Video](https://drive.google.com/file/d/1D80R41BOParI8f31nbzXNWi7wXw-dVWa/view);  [Figma Wireframe (Old)](https://www.figma.com/design/zFOUI2k38kZSWLhMXAM1sV/Nextern-App?node-id=0-1&p=f&t=6eFbiWd7greXp48c-0).

## Objectives

- Provide learners with access to available learning programs and internships.
- Enable learners to monitor their learning progress and resume active programs.
- Allow learners to submit assignments and access certificates.
- Support program applications with validation and visible enrolment states.
- Allow learners to save programs and retain those choices between sessions.
- Help administrators create and manage programs, learners, submissions, announcements, and enrolment requests.
- Create a consistent mobile experience for learner and administrator roles.
- Maintain a reusable Flutter structure that can later connect to a live backend API.

## Week 3 Update

Week 3 moved Nextern beyond a mainly visual prototype by introducing structured local data, shared state management, persistent saved programs, validated enrolment forms, application-status tracking, expanded learning tools, and more complete administrator workflows.

### Main Improvements

- Replaced hard-coded program listings with a local JSON file that acts as a mock API.
- Added a reusable `Program` model with validation for required fields and safe fallback values for optional data.
- Added shared program state using a singleton `ProgramStore` built with `ChangeNotifier`.
- Added saved-program persistence using `SharedPreferences`.
- Connected Browse, Home, and Program Details to the same program and bookmark state.
- Added loading, empty, error, and retry states to the program-discovery flow.
- Added a reusable `ProgramApplicationForm` with field validation and submission states.
- Connected applications to `EnrollmentService` and visible statuses such as **Under Review**, **Accepted**, and **Rejected**.
- Expanded the learner Home screen, Learning Hub, assignment submission flow, profiles, notifications, and certificates.
- Expanded the administrator dashboard, Program Manager, enrolment review, user management, announcements, and security settings.
- Created a Figma application-flow diagram covering learner and administrator navigation.

<img src="docs/images/week3-functional-workflows.png" alt="Nextern learner dashboard, Learning Hub, and administrator enrolment review screens" width="100%" />

The image above highlights the connected Week 3 workflows: learner progress and resume actions, weekly learning content and assignment submission, and administrator review of enrolment requests.

## Navigation Flow

### Learner Flow

1. **Login / Sign Up** → Log in or create a learner account.
2. **Dashboard (Home)** → View active-program progress, announcements, pending assignments, notifications, and saved programs.
3. **Browse** → Explore programs and internships using live search, quick filters, a bottom-sheet filter, and Load More pagination.
4. **Program Details** → Review information loaded from the shared program data source, save the program, or begin an application.
5. **Application Form** → Submit experience level, reason for joining, an optional portfolio URL, and confirmation.
6. **Application Status** → Track the application as Under Review, Accepted, or Rejected.
7. **Learning Hub** → Access accepted programs, weekly modules, learning resources, progress tracking, and assignment dropboxes.
8. **Tasks** → View active assignments, submit work, monitor submission status, and access certificates.
9. **Profile** → Edit profile information, manage notifications and security, send feedback, access Help Centre support, and log out.

The learner bottom navigation bar—Home, Browse, Tasks, and Profile—allows users to move between the main areas of the application. Resume Learning actions connect the Home screen directly to active learning content.

### Administrator Flow

1. **Admin Login** → Access the administrator interface using the **Login as Admin** option.
2. **Admin Dashboard** → View learner totals, active-program counts, recent activity, quick actions, submissions, and announcements.
3. **Programs** → Search programs, create new programs, edit or delete existing programs, build modules, set schedules, and enforce submission deadlines.
4. **Program Management** → Review submissions, open attached files, filter by module or status, assign grades, and process enrolment requests.
5. **Users** → Search and filter learners by status, risk, or enrolment; view profiles; reset passwords; or suspend accounts.
6. **Admin Profile** → Edit account information, manage administrator preferences, configure security and two-factor authentication, and log out.

The administrator bottom navigation bar—Dashboard, Programs, Users, and Profile—provides access to the main management areas.

## Student Features

- **Login** – Account creation using name, email, password, and acceptance of the terms and conditions; email-password login; password recovery; Google sign-in; and a separate Admin Login entry point.
- **Home** – Active-program carousel, course-completion progress, current module, Resume Learning action, announcements, pending assignments, saved programs, and interactive notifications.
- **Browse** – Live program search, category and tag filters, bottom-sheet filtering, Load More pagination, bookmarking, and access to Program Details.
- **Program Details** – Dynamic image, company, description, duration, effort, level, format, instructor information, learning outcomes, saved state, and application status.
- **Applications** – Reusable enrolment form with validation for experience level, reason for joining, optional portfolio URL, and confirmation.
- **Learning Hub** – Weekly collapsible modules, learning materials, progress tracking, media and document viewing, file selection, and assignment submission.
- **Tasks** – Separate active-course and certificate views, due dates, submission statuses, and downloadable certificates.
- **Profile** – Edit Profile, Notification Settings, Security, Feedback, Help Centre, and logout.

<img src="https://github.com/user-attachments/assets/94109610-81a2-4513-addb-2b4e9d57a8ed" alt="Nextern student interface screens" width="100%" />

> **Note:** The image above highlights the original learner interface screens and does not represent the complete Week 3 flow. Refer to the [Demo Video](https://drive.google.com/file/d/1D80R41BOParI8f31nbzXNWi7wXw-dVWa/view) for account creation, navigation, program discovery, application, learning, assignment, certificate, and logout workflows.

## Dynamic Program Data and Saved Programs

Program listings are stored in `assets/data/programs.json`, which acts as the current mock data source. The original five records were moved out of the UI code and registered as Flutter assets.

The program-data implementation includes:

- `Program` – Validates required fields and provides fallback values for optional data.
- `ProgramService` – Loads and parses JSON, removes inactive records, sorts by display order, and reports malformed data.
- `SavedProgramService` – Stores bookmarked program IDs using `SharedPreferences`.
- `ProgramStore` – Exposes program data, loading state, error state, and saved IDs through `ChangeNotifier`.
- `initialize()` – Loads the initial program and bookmark state.
- `retry()` – Reattempts loading after an error.
- `toggleSaved()` – Saves or removes a bookmarked program and updates connected screens.

Browse, Home, and Program Details read from the same store. A saved program therefore appears consistently across the application and remains saved after a restart.

<img src="docs/images/week3-dynamic-program-data.png" alt="JSON program record, dynamic Program Details screen, and synchronized saved-program section" width="100%" />

The image above demonstrates the data path from the JSON record to Program Details and the learner Home screen.

## Program Application and Enrolment

A reusable `ProgramApplicationForm` was added to the Program Details flow and connected to `EnrollmentService`.

The form collects:

- Experience level
- Reason for joining
- Optional portfolio URL
- Confirmation that the submitted information is accurate

Validation prevents submission until required fields are completed, validates the portfolio URL when one is entered, and requires the confirmation checkbox. The form also supports loading, success, and error states. After a successful submission, the learner sees confirmation and the application status changes to **Under Review**.

<img src="docs/images/week3-application-form.png" alt="Empty enrolment form, validation feedback, and successful application submission" width="100%" />

The image above shows the empty form, a validation state, and successful submission confirmation.

## Admin Features

- **Dashboard** – View total learners, active-program counts, recent activity, quick actions, announcements, and recent submissions.
- **Programs** – Search, create, edit, and delete programs; configure schedules; add modules and resources; and enforce submission deadlines.
- **Submissions** – Filter learner work by module or status, review attached files, provide decisions or grades, and view previous results.
- **Enrolment Requests** – Review the learner’s reason for joining and accept or decline the application through shared application state.
- **Users** – Search and filter learners, view profiles, reset passwords, suspend accounts, and monitor enrolment or risk status.
- **Announcements** – Create announcements with a title, description, and resource attachments, then synchronize them with learner dashboards.
- **Profile and Settings** – Edit administrator information, manage preferences, configure security and two-factor authentication, and log out.

<img src="https://github.com/user-attachments/assets/b0c78a86-cbee-428e-acf3-cb49bf5622d5" alt="Nextern administrator interface screens" width="100%" />

> **Note:** The image above highlights selected original administrator screens. The Week 3 screenshot near the top of this README demonstrates the newer Program Manager and enrolment-review workflow.

## Loading and Error Handling

The program-discovery flow includes user-facing states for:

- **Loading** – Indicates that program records are being prepared.
- **Success** – Displays active records in the Browse interface.
- **Empty data** – Shows a message when no programs are available.
- **Error** – Displays a descriptive message when JSON loading or parsing fails.
- **Retry** – Allows the learner to attempt loading again.
- **Form loading** – Prevents duplicate submissions while an application is being processed.
- **Form success** – Confirms submission and updates enrolment status.
- **Form error** – Explains that the application failed and allows another attempt.

## Technical Structure

```text
assets/
└── data/
    └── programs.json

lib/
├── models/
│   └── program.dart
├── services/
│   ├── program_service.dart
│   ├── saved_program_service.dart
│   └── enrollment_service.dart
├── stores/
│   └── program_store.dart
├── widgets/
│   └── program_application_form.dart
└── screens/
    ├── browse/
    ├── program_details/
    ├── learning_hub/
    ├── learner_profile/
    └── admin/
```

The exact folder names may differ as the project continues to be reorganized, but the implementation separates data models, services, shared state, reusable widgets, and screens.

## Technologies Used

### Development

- Flutter
- Dart
- Kotlin
- Swift
- Gradle

### Data and State

- Local JSON assets
- `ChangeNotifier`
- Singleton shared store
- `SharedPreferences`

### Design

- Figma

### Version Control

- Git
- GitHub

### Packages and Local Storage

- `cupertino_icons`
- `shared_preferences`

## Current Data Approach

The local JSON file currently acts as an offline mock API. This keeps the app functional without a network connection and provides a reusable data structure for Browse, Home, and Program Details. The service layer and shared store are designed so that the local source can later be replaced with a remote API or backend service.

## Team 18 Task split

- Jonathan Goforth : Dynamic Program Data and Saved Programs, GitHub repository management, video editing and deliverables doccumentation
- Renz Paulo Baltazar : Figma wireframe, UI/UX design, Cross-App Functional Expansion and Workflow Improvements
- Favour Chigemezu Uzochukwu: Program Application Form and Enrolment Submission
- Sadaf : Merged code QA
