# Nextern Project History

> This document records the development of Nextern across Weeks 1–4.
> For installation instructions, release downloads, current screenshots, and the latest project information, refer to the main [README](../README.md).

---

## Project Overview

Nextern is a Flutter application that connects learners with structured learning programs and internships while providing administrators with tools to manage programs, learners, applications, assignments, announcements, and progress.

The project developed from an initial proposal and navigation plan into a complete learner and administrator application with structured local data, persistent state, validated application workflows, automated testing, GitHub Actions, and a signed Android release.

Version `1.0.0+4` represents the first complete open-source release of Nextern.

## Project Resources

* [Current project README](../README.md)
* [Download Nextern v1.0.0 Android APK](https://github.com/Jonathan-Go4th/Project-Nextern/releases/download/v1.0.0/Nextern-v1.0.0-android-universal.apk)
* [Watch the final demonstration video](https://drive.google.com/file/d/1cX7cx7BBhUqAp2TToiCAfmpFB16ibm8b/view)
* [View the updated Figma design](https://www.figma.com/design/zFOUI2k38kZSWLhMXAM1sV/Nextern-App?node-id=92-55&t=Xy7SYgtqdB2bLa33-0)
* [Week 1 App Proposal](../Nextern%20-%20App%20Proposal.pdf)
* [Week 2 Development Documentation](../Nextern%20-%20Deliverables%20Week%202.pdf)
* [Week 3 Development Documentation](../Nextern_Week_3_Development_Documentation.pdf)
* [Project Changelog](../CHANGELOG.md)

---

# Week 1 — Project Proposal and Foundation

## Week 1 Goal

Week 1 focused on defining the purpose, intended users, planned features, navigation structure, development technologies, and initial repository foundation for Nextern.

At this stage, Nextern was primarily a proposed mobile application intended to make learning programs easier to discover and manage.

## Project Vision

The original vision was to create a mobile application that:

* Gives learners access to available learning programs.
* Allows learners to monitor their progress.
* Provides assignment and certificate workflows.
* Gives administrators tools for managing programs and learner activity.
* Maintains a simple and consistent mobile experience for both learner and administrator roles.

## Target Users

Nextern was designed for two main user groups.

### Learners

Learners needed a simple way to:

* Discover learning programs and internships.
* Monitor active learning progress.
* View and submit assignments.
* Access certificates.
* Manage their profile and account information.

### Administrators

Administrators needed tools to:

* Monitor learner activity.
* Manage learning programs.
* Review learner progress and submissions.
* Publish updates and announcements.
* Manage application and platform information.

## Planned Learner Navigation

The original learner flow was:

1. **Login or Sign Up** — Create a learner account or log in.
2. **Home** — View course progress, the current module, and saved programs.
3. **Browse** — Explore available programs and internships.
4. **Tasks** — View assignments, submission states, and certificates.
5. **Profile** — View and manage learner account information.

The planned learner bottom navigation contained:

* Home
* Browse
* Tasks
* Profile

## Planned Administrator Navigation

The original administrator flow was:

1. **Administrator Sign Up or Login**
2. **Administrator Dashboard**
3. **Learner and Assignment Monitoring**
4. **User and Program Management**
5. **Settings**

The initial administrator navigation concept included:

* Dashboard
* Users
* Updates
* Settings

## Initial Technology Decisions

The following technologies were selected during Week 1:

### Development

* Flutter
* Dart

### Design

* Figma

### Version Control

* Git
* GitHub

Flutter was selected to support a shared application codebase, while Figma was used to design the learner and administrator interfaces before implementation.

## Repository Foundation

The initial repository work included:

* Creating the GitHub repository.
* Adding the app proposal.
* Creating the first project README.
* Adding the initial Flutter project structure.
* Preparing the repository for collaborative development.
* Connecting the README to the proposal and design resources.

## Week 1 Deliverables

* Project vision and objectives
* Learner and administrator user definitions
* Learner navigation plan
* Administrator navigation plan
* Initial feature requirements
* Figma wireframe
* App proposal document
* GitHub repository
* Initial Flutter project structure
* Initial project README

---

# Week 2 — Functional UI Prototype

## Week 2 Goal

Week 2 transformed the proposal and wireframes into a navigable Flutter prototype.

The main objective was to implement the key learner and administrator screens and demonstrate navigation between them.

At this stage, much of the application content was still prototype or locally defined data. The shared data, persistent application state, and enrolment systems introduced during Week 3 had not yet been completed.

## Learner Experience Implemented

### Authentication

The learner authentication interface included:

* Account creation with name, email, and password
* Terms and conditions confirmation
* Email and password login
* Password recovery
* Google sign-in interface
* Separate **Login as Admin** entry point

The authentication screens established the visual entry point for both application roles.

### Learner Home

The initial learner Home screen displayed:

* Course-completion percentage
* Current learning module
* Resume Learning action
* Saved or favourite programs

The Home screen acted as the main overview for learner activity.

### Program Discovery

The Browse interface allowed learners to:

* View available programs and internships.
* Search program listings.
* Filter opportunities by category.
* Filter by program mode or type.
* Save opportunities.
* Open a Program Details screen.

The Program Details interface presented additional information about an opportunity and provided a foundation for the application workflow added later.

### Tasks and Certificates

The Tasks interface introduced:

* Active assignments
* Assignment due dates
* Submitted states
* Under-review states
* Assignment-submission actions
* Certificate viewing
* Certificate download actions

### Learner Profile

The initial Profile interface allowed learners to:

* View account information.
* Access profile-related options.
* Log out of the application.

## Administrator Experience Implemented

### Administrator Login

Administrators could access a separate login route through the **Login as Admin** option on the learner login screen.

### Administrator Dashboard

The prototype administrator dashboard displayed:

* Active-user totals
* Average program completion
* Quick actions
* Recent learner submissions

### Learner Monitoring

The Users area allowed administrators to:

* View learners.
* Monitor learning progress.
* Review feedback and support-related information.

### Announcements

The Updates area introduced an interface for creating and managing learner announcements.

### Settings

An administrator Settings area was included as a placeholder for later profile, preference, and security functionality.

## Navigation Progress

Week 2 completed working bottom-navigation structures for the two roles.

### Learner Navigation

```text
Home → Browse → Tasks → Profile
```

### Administrator Navigation

```text
Dashboard → Users → Updates → Settings
```

The key screens were connected into a functional prototype rather than remaining isolated interface mock-ups.

## Week 2 Interface Screens

### Learner Interface

<img src="https://github.com/user-attachments/assets/94109610-81a2-4513-addb-2b4e9d57a8ed" alt="Nextern learner prototype screens" width="100%" />

### Administrator Interface

<img src="https://github.com/user-attachments/assets/b0c78a86-cbee-428e-acf3-cb49bf5622d5" alt="Nextern administrator prototype screens" width="100%" />

These images represent the early application interface. Several screens and workflows were expanded or redesigned during Weeks 3 and 4.

## Week 2 Deliverables

* Flutter learner interface
* Flutter administrator interface
* Login and account-creation screens
* Learner Home screen
* Program Browse screen
* Program Details screen
* Tasks and certificate interface
* Learner Profile screen
* Administrator Dashboard
* Learner-monitoring interface
* Announcement-management interface
* Working learner navigation
* Working administrator navigation
* Updated Figma wireframe
* Prototype demonstration video
* Week 2 development document
* Updated project README

---

# Week 3 — Data Integration and Complete Workflows

## Week 3 Goal

Week 3 moved Nextern beyond a mainly visual prototype.

The main focus was to introduce structured application data, reusable services, shared state, persistent saved programs, validated applications, enrolment-status tracking, learning workflows, and more complete administrator functionality.

## Dynamic Program Data

Program information was moved from hard-coded screen data into:

```text
assets/data/programs.json
```

This local JSON file became the application's mock program-data source.

A reusable `Program` model was added to:

* Validate required fields.
* Parse structured program records.
* Provide fallback values for optional data.
* Support consistent program information across multiple screens.

## Program Service

`ProgramService` was introduced to manage the program data.

Its responsibilities included:

* Loading the JSON asset.
* Parsing program records.
* Removing inactive records.
* Sorting records by display order.
* Reporting invalid or malformed data.

Separating data loading from the interface reduced duplication and made the application easier to maintain.

## Shared Program Store

A singleton `ProgramStore` was created using `ChangeNotifier`.

The shared store exposed:

* Program records
* Loading state
* Error state
* Saved-program identifiers
* Initialization operations
* Retry operations
* Bookmark updates

Browse, Home, and Program Details were connected to the same shared program state.

A program loaded or saved in one screen therefore remained consistent across the rest of the application.

## Persistent Saved Programs

`SavedProgramService` used `SharedPreferences` to store bookmarked program IDs.

This allowed learners to:

* Save a program from Browse.
* Save or remove a program from Program Details.
* View saved programs on the learner Home screen.
* Retain saved choices after restarting the application.

## Dynamic Program Data Workflow

<img src="images/week3-dynamic-program-data.png" alt="Program JSON data, dynamic Program Details, and saved-program synchronization" width="100%" />

The image demonstrates the connection between:

1. The JSON program record
2. The Program Details screen
3. The saved-program section on the learner Home screen

## Program Application and Enrolment

A reusable `ProgramApplicationForm` was added to the Program Details workflow.

The form collected:

* Experience level
* Reason for joining
* Optional portfolio URL
* Confirmation that the submitted information was accurate

Validation was added for:

* Required experience selection
* Required reason for joining
* Portfolio URL format
* Confirmation checkbox
* Incomplete submissions

The form supported:

* Loading state
* Successful submission state
* Submission error state

Applications were connected to `EnrollmentService`.

After a successful application, the learner could see an enrolment state such as:

* **Under Review**
* **Accepted**
* **Rejected**

## Application Form Workflow

<img src="images/week3-application-form.png" alt="Nextern application form, validation, and successful enrolment submission" width="100%" />

The image demonstrates:

1. The empty application form
2. Validation feedback
3. Successful submission confirmation

## Expanded Learner Home

The learner Home screen was expanded to include:

* Active-program carousel
* Course-completion progress
* Current learning module
* Resume Learning action
* Announcements
* Pending assignments
* Saved programs
* Interactive notifications

The Resume Learning action connected the Home screen directly to active learning content.

## Expanded Program Discovery

The Browse workflow was expanded with:

* Live search
* Category filters
* Tag filters
* Quick filters
* Bottom-sheet filtering
* Load More pagination
* Bookmarking
* Empty-data states
* Loading states
* Error states
* Retry actions

## Expanded Program Details

Program Details displayed:

* Program image
* Program title
* Company or provider
* Description
* Duration
* Expected effort
* Difficulty level
* Delivery format
* Instructor information
* Learning outcomes
* Saved state
* Application state

The learner could save the program or start the application process from the same screen.

## Learning Hub

A Learning Hub was introduced for accepted or active programs.

It included:

* Weekly collapsible modules
* Learning materials
* Progress tracking
* Media resources
* Document resources
* File selection
* Assignment submission
* Submission feedback

## Tasks and Certificates

The Tasks area was expanded with:

* Separate active-course and certificate views
* Assignment due dates
* Submission status
* Under-review status
* Completed status
* Certificate access
* Certificate download actions

## Learner Profile

The learner profile workflow was expanded with:

* Edit Profile
* Notification Settings
* Security
* Feedback
* Help Centre
* Logout

## Expanded Administrator Dashboard

The administrator dashboard was expanded to display:

* Total learners
* Active-program totals
* Recent activity
* Quick actions
* Recent submissions
* Announcements

## Program Management

Administrators gained tools to:

* Search programs.
* Create programs.
* Edit programs.
* Delete programs.
* Add learning modules.
* Add resources.
* Configure schedules.
* Set submission deadlines.
* Review program activity.

## Submission Review

Administrators could:

* Filter submissions by module.
* Filter submissions by status.
* Open attached files.
* Review learner work.
* Assign grades or results.
* View previous submission results.

## Enrolment Review

Administrators could:

* View learner application details.
* Review the learner's reason for joining.
* Review supporting information.
* Accept enrolment requests.
* Decline enrolment requests.
* Update shared application state.

## User Management

Administrators gained tools to:

* Search learners.
* Filter learners by status.
* Filter learners by enrolment.
* Filter learners by risk.
* View learner profiles.
* Reset passwords.
* Suspend accounts.
* Review progress and enrolment indicators.

## Announcements

Administrators could create announcements containing:

* Title
* Description
* Supporting resources or attachments

Published announcements appeared within the learner experience.

## Administrator Profile and Settings

The administrator profile workflow was expanded with:

* Edit Profile
* Administrator preferences
* Security settings
* Two-factor authentication interface
* Logout

## Loading and Error Handling

User-facing states were introduced for:

* Loading program data
* Successful data loading
* Empty program data
* Data-loading errors
* Retry actions
* Form loading
* Form success
* Form failure

These states made the application more reliable and prevented the user from seeing blank or unexplained interfaces during data operations.

## Week 3 Functional Workflows

<img src="images/week3-functional-workflows.png" alt="Learner dashboard, Learning Hub, and administrator enrolment review" width="100%" />

The image demonstrates three important Week 3 workflows:

1. Learner progress and Resume Learning
2. Weekly learning content and assignment submission
3. Administrator review of learner enrolment requests

## Week 3 Technical Structure

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

The implementation separated:

* Models
* Services
* Shared state
* Reusable widgets
* Learner screens
* Administrator screens

## Week 3 Deliverables

* Structured local program data
* Reusable Program model
* Program-loading service
* Shared ProgramStore
* Persistent saved programs
* Connected Browse, Home, and Program Details
* Validated program application form
* EnrollmentService integration
* Application-status tracking
* Expanded learner Home
* Expanded Browse workflow
* Expanded Program Details
* Learning Hub
* Assignment-submission workflow
* Task and certificate improvements
* Expanded learner profile
* Expanded administrator dashboard
* Program-management tools
* Submission-review tools
* Enrolment-review workflow
* User-management tools
* Announcement workflow
* Administrator profile and settings
* Program-data and store tests
* Updated Figma application-flow diagram
* Week 3 development document
* Updated README and screenshots

---

# Week 4 — Final Integration, Quality Assurance and Release

> Week 4 records only the work added after the Week 3 implementation. Features already completed during Weeks 2 and 3 are not presented as new Week 4 work.

## Week 4 Goal

The final week focused on turning the integrated Week 3 application into a stable, testable, documented, distributable, and open-source release.

The main areas were:

* Cross-app integration
* Navigation fixes
* UI and branding consistency
* Code review and cleanup
* Automated testing
* Continuous integration
* Android release configuration
* APK signing and verification
* Release documentation
* Open-source repository preparation

## Native Splash Screen

A native splash screen was introduced to improve the startup experience.

The splash screen gave the application:

* A branded startup state
* Better visual continuity
* A more professional launch experience
* Improved transition into the main authentication flow

## UI and UX Polish

Final UI improvements included:

* More consistent styling across learner and administrator screens
* Improved authentication forms
* Profile-screen polish
* Better spacing
* More consistent interface components
* Improved visual hierarchy
* Better navigation behaviour
* Final branding and icon integration

## Navigation Fixes

Final integration testing identified a black-screen issue when navigating between learner portal screens.

The navigation problem was corrected to ensure smoother movement across:

* Home
* Browse
* Program Details
* Tasks
* Learning Hub
* Profile

Additional post-refactor issues were also identified and corrected during code review.

## Administrator Cleanup

The administrator implementation was cleaned by:

* Removing unused dashboard code.
* Removing unused imports.
* Correcting post-refactor problems.
* Reducing analyzer warnings.
* Removing obsolete implementation fragments.

## Final Application Scope

By the final week, Nextern contained the required core screens:

### Learner Screens

* Login
* Sign Up
* Password Recovery
* Home
* Program Listing
* Program Details
* Program Application Form
* Learning Hub
* Tasks
* Assignment Submission
* Certificates
* Notifications
* Profile
* Feedback
* Help Centre
* Security Settings

### Administrator Screens

* Administrator Login
* Administrator Dashboard
* Program Manager
* Program Creation
* Program Editing
* Learner Management
* Learner Profiles
* Enrolment Review
* Submission Review
* Announcement Management
* Administrator Profile
* Administrator Preferences
* Security Settings

## Automated Tests

The final release included **24 automated tests**.

The test coverage included important areas such as:

* Program-data parsing
* Invalid program data
* Program sorting
* Program-store initialization
* Saved-program state
* Bookmark behaviour
* Application validation
* Service behaviour
* Shared workflow state
* Key widgets

All 24 automated tests passed for the final release.

## Flutter Analysis

The final release passed Flutter static analysis without warnings or errors.

The project used:

```bash
flutter analyze --no-fatal-infos
```

Informational Flutter recommendations remain visible, while analyzer warnings and errors continue to fail the automated workflow.

## GitHub Actions

A Flutter GitHub Actions workflow was added.

The workflow performs:

```text
flutter pub get
flutter analyze --no-fatal-infos
flutter test
```

The workflow runs for:

* Pushes to `main`
* Pushes to release branches
* Pull requests targeting `main`

Concurrency control was configured so obsolete workflow runs can be cancelled when newer commits are pushed.

## Repository Cleanup

Release preparation included:

* Stopping the tracking of Flutter-generated macOS files
* Excluding generated build outputs
* Excluding APK build directories
* Excluding signing credentials and private keys
* Removing unused administrator-dashboard code
* Cleaning unused imports
* Organizing the documentation directory
* Separating current project information from historical development documentation

## Open-Source Documentation

The following repository documents were added or finalized:

* `README.md`
* `CHANGELOG.md`
* `CONTRIBUTING.md`
* `SECURITY.md`
* `CODE_OF_CONDUCT.md`
* `LICENSE`
* `docs/PROJECT_HISTORY.md`

GitHub contribution templates were also added:

* Bug-report template
* Feature-request template
* Pull-request template
* Security-reporting guidance

## Final README

The main project README was rewritten to focus on current users and contributors.

It includes:

* Project overview
* Learner features
* Administrator features
* Screenshots
* Android installation instructions
* Development setup
* Test and analysis commands
* Android build instructions
* Architecture overview
* Repository structure
* Documentation links
* Team contributions
* Licence information

The longer Week 1–4 history was moved into this document so the main README could remain focused on the current release.

## Release Metadata

The final Android release was configured with:

```text
Application ID: com.team18.nextern
Version name: 1.0.0
Version code: 4
Flutter version: 1.0.0+4
```

The permanent Android application ID replaced the default development identifier.

## Android Signing

A permanent Team 18 release-signing configuration was created.

The signed APK was verified with the signer identity:

```text
Nextern Team 18 / Excelerate
```

Private signing credentials and key files were excluded from Git.

## Android APK

A signed universal Android APK was built and published as:

```text
Nextern-v1.0.0-android-universal.apk
```

Download:

[Download Nextern v1.0.0 for Android](https://github.com/Jonathan-Go4th/Project-Nextern/releases/download/v1.0.0/Nextern-v1.0.0-android-universal.apk)

Verified SHA-256:

```text
FFFA1A184F0439B473576F90597D6A2325FA32664886FB45F0C0C07BE80D23A9
```

## Version 1.0.0 Release

The release branch was merged into `main` through:

[Pull Request #2 — release: Nextern v1.0.0](https://github.com/Jonathan-Go4th/Project-Nextern/pull/2)

The final release verification confirmed:

* Flutter CI passed
* All 24 automated tests passed
* The Android APK built successfully
* The APK signature was verified
* Package metadata was verified
* Version metadata was verified
* Signing credentials were excluded from Git
* Release documentation was completed

## Week 4 Deliverables

* Final integrated Flutter application
* Native splash screen
* Final UI and UX polish
* Cross-screen navigation fixes
* Post-refactor bug fixes
* Profile-screen polish
* Administrator code cleanup
* Automated Flutter tests
* GitHub Actions analysis and test workflow
* Final Android APK build
* Permanent Android application ID
* Android release-signing configuration
* Signed and verified universal APK
* Version `1.0.0+4`
* GitHub v1.0.0 release
* Final demonstration video
* Changelog
* Contribution guide
* Security policy
* Code of conduct
* MIT licence
* Issue and pull-request templates
* Polished project README
* Archived four-week project history

---

# Final Application Architecture

Nextern currently follows a local-first architecture.

```text
assets/data/programs.json
        │
        ▼
  ProgramService
        │
        ▼
    ProgramStore
        │
        ├── Browse
        ├── Home
        └── Program Details

SharedPreferences
        │
        ├── Saved programs
        └── Local session state
```

The application separates:

* Data models
* Data-loading services
* Local persistence services
* Shared state stores
* Reusable widgets
* Learner screens
* Administrator screens

This structure allows the local JSON data source and local services to be replaced by a remote backend in a future version.

> Nextern v1.0.0 is a demonstrable learning-platform application. Authentication, program data, and workflow state are primarily local and should not be treated as a production backend or production identity system.

---

# Development Timeline

| Week       | Development Stage             | Main Result                                                                                                                                |
| ---------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| **Week 1** | Planning and foundation       | Defined the project vision, learner and administrator flows, Figma design, proposal, repository, and initial Flutter structure.            |
| **Week 2** | Functional prototype          | Implemented the main learner and administrator screens with working navigation.                                                            |
| **Week 3** | Data and workflow integration | Added structured program data, shared state, saved programs, enrolment applications, learning workflows, and expanded administrator tools. |
| **Week 4** | Quality assurance and release | Completed integration fixes, UI polish, automated testing, CI, documentation, Android signing, APK packaging, and the v1.0.0 release.      |

For detailed technical changes and individual commits, refer to the repository's [commit history](https://github.com/Jonathan-Go4th/Project-Nextern/commits/main/) and [changelog](../CHANGELOG.md).

---

# Team 18 Contributions

| Contributor                    | Primary Contributions                                                                                                                                                                                                     |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Jonathan Goforth**           | Dynamic program data, saved programs, `ProgramStore` and `ProgramService`, SharedPreferences persistence, CI/CD workflow, repository management, Android release packaging, video editing, and deliverable documentation. |
| **Renz Paulo Baltazar**        | Figma wireframes, UI/UX design, native splash screen, profile-screen polish, authentication-form improvements, cross-app workflow expansion, and interface consistency fixes after integration.                           |
| **Favour Chigemezu Uzochukwu** | Program application form, field validation, portfolio URL validation, submission-state handling, `EnrollmentService` integration, and enrolment-status tracking.                                                          |
| **Sadaf**                      | Merged-code quality assurance, post-refactor bug fixes, and administrator Home screen import cleanup.                                                                                                                     |

---
