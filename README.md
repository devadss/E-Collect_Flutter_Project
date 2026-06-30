# Login & User Onboarding Workflow

## Overview

The application supports the following user types:

1. Merchant
2. RD / RDCL / Loan Agent
3. Member

The user enters their mobile number and verifies it using OTP. The system validates the mobile number against Merchant, Member, and Agent records to determine the appropriate user flow.

---

# User Classification

| Condition                                                          | User Type              | Action                          |
| ------------------------------------------------------------------ | ---------------------- | ------------------------------- |
| Mobile number belongs to a registered Merchant                     | Merchant               | Redirect to Merchant Dashboard  |
| Mobile number belongs to a Member (assigned to one or more groups) | Member                 | Redirect to Member Dashboard    |
| Mobile number belongs to an RD / RDCL / Loan Agent                 | RD / RDCL / Loan Agent | Redirect to Agent Dashboard     |
| Mobile number does not match any Merchant, Member, or Agent record | New Merchant           | Redirect to Merchant Onboarding |

---

# Merchant Workflow

## First-Time Login (Onboarding)

If the merchant has not completed onboarding, collect the following information.

### Personal Details

* Full Name
* Mobile Number
* Address

### Identity Proof

* Aadhaar Number **or** PAN Number
* Upload Aadhaar/PAN Image

### Business Details

* Business Name
* Business Type
* Business License Image

After successful submission:

* Account Status: **Pending Verification**

---

## Verification Process

The backend/admin verifies:

* Identity Proof
* Business License
* Business Details

Once approved:

* Status changes to **Verified**
* Merchant features are enabled.

---

## Merchant Home Dashboard

### Before Verification

### Visible Information

* Total Groups
* Amount Collected
* Pending Amount

### Disabled Features

* Create Group
* Add Members
* Collections
* Reports
* Reminder Settings

Display message:

> Your account is under verification. Features will be enabled after approval.

---

### After Verification

### Enabled Features

* Dashboard
* Create Group
* Add Members
* Collections
* Reports
* Reminder Settings
* Profile

### Dashboard Summary

* Total Groups
* Total Members
* Total Collection
* Pending Collection
* Upcoming Dues

---

## Create Group

Merchants can create multiple collection groups.

### Example

For a Tuition Center:

* Morning Batch
* Evening Batch

### Group Details

* Group Name
* Collection Frequency
* Collection Date
* Due Amount

---

## Add Members

Each member record contains:

* Member Name
* Mobile Number
* Member Number
* Due Amount
* Collection Date

---

## Reminder Configuration

Merchants can configure reminders using:

* WhatsApp
* SMS
* Phone Call

### Additional Settings

* Reminder Date
* WhatsApp Charges
* Call Charges

---

## Merchant Profile

Profile includes:

* Personal Details
* Business Details
* Uploaded Documents
* Verification Status
* Edit Profile
* Logout

---

# RD / RDCL / Loan Agent Workflow

The FRD specifies that RD, RDCL, and Loan Agents follow the existing **e-Collect** workflow.

Available features include:

* Dashboard
* RDCL Member Listing
* Payment Collection
* Collection History
* Profile

---

# Member Workflow

## Login Validation

If the mobile number belongs to a registered Member and is associated with one or more groups:

* Login succeeds.
* Redirect the user to the Member Dashboard.

---

## Member Dashboard

Display:

* My Groups
* Transaction History
* Paid Amount
* Pending Dues
* Upcoming Dues
* Next Due Date

---

## Transaction History

For each group, display:

* Payment Date
* Amount Paid
* Pending Amount
* Due Date
* Payment Status

---

## Notifications

Members receive reminders based on the Merchant's configuration through:

* WhatsApp
* SMS
* Phone Call

---

# Complete Login Decision Flow

```text
User Enters Mobile Number
          │
          ▼
    OTP Verification
          │
          ▼
Is Merchant Registered?
          │
     ┌────┴────┐
     │         │
    Yes        No
     │         │
     ▼         ▼
Merchant     Is Member?
Dashboard        │
            ┌────┴────┐
            │         │
           Yes        No
            │         │
            ▼         ▼
     Member Dashboard  Is Agent?
                           │
                     ┌─────┴─────┐
                     │           │
                    Yes          No
                     │           │
                     ▼           ▼
             Agent Dashboard  Merchant Onboarding
                                   │
                                   ▼
                         Pending Verification
                                   │
                                   ▼
                           Admin Approval
                                   │
                                   ▼
                          Merchant Dashboard
```

---

# Functional Summary

| Feature                | Merchant | RD / RDCL / Loan Agent | Member |
| ---------------------- | :------: | :--------------------: | :----: |
| OTP Login              |     ✅    |            ✅           |    ✅   |
| Onboarding             |     ✅    |          N/A*          |    ❌   |
| Admin Verification     |     ✅    |            ✅           |    ❌   |
| Dashboard              |     ✅    |            ✅           |    ✅   |
| Create Groups          |     ✅    |            ❌           |    ❌   |
| Add Members            |     ✅    |            ❌           |    ❌   |
| Member Listing         |     ✅    |            ✅           |    ❌   |
| Collection Management  |     ✅    |            ✅           |    ❌   |
| Transaction History    |     ✅    |            ✅           |    ✅   |
| Due Tracking           |     ✅    |            ✅           |    ✅   |
| Reminder Configuration |     ✅    |            ❌           |    ❌   |
| Profile Management     |     ✅    |            ✅           |    ✅   |

*** Note:** If RD/RDCL/Loan Agents are allowed to self-register in the future, the **Onboarding** feature can be changed from **N/A** to **✅**.
