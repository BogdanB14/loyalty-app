# CLAUDE.md — Project Conventions

## Architecture
- Clean Architecture: data / domain / presentation layers per feature
- State management: Riverpod (riverpod_annotation for code gen)
- Navigation: go_router with ShellRoute for bottom nav
- HTTP: Dio with AuthInterceptor for JWT

## Naming
- Files: snake_case
- Classes: PascalCase
- Riverpod providers: camelCase ending in Provider
- Use cases: verb + noun (e.g. ScanReceiptUseCase)

## Backend
- Base URL: http://10.0.2.2:8080/api (emulator)
- Auth: Bearer JWT in Authorization header
- All models have .fromJson() and .toJson()

## Do not
- Use setState in feature screens (use Riverpod)
- Import across feature boundaries (use core/ for shared)
- Hardcode strings (use ApiConstants)

## App Idea and Specification:
Loyalty Rewards Mobile Application for Hospitality Venues (Serbia)
1.Project Overview
The goal of this project is to build a mobile loyalty application for hospitality venues in the Republic of Serbia. The application will reward loyal customers based on purchases made in participating venues.
Customers receive a fiscal receipt after payment, which contains a QR code issued by the Serbian Tax Administration (Poreska uprava Republike Srbije). By scanning this QR code in the mobile application, the system retrieves the receipt data and awards loyalty points to the customer.
Customers can optionally share the earned points with friends who were present during the visit.
Venues can define their own loyalty rules, including:
point calculation formula
promotions
rewards
promotion roadmap
The purpose of the application is to increase customer retention and loyalty for hospitality venues.

2.Technology Stack
Mobile Application: Flutter (iOS and Android support)
Fully responsive UI
Backend - Java - Sent repo
Recommended stack:
Java Spring Boot
PostgreSQL database
JWT authentication
REST API

Optional:
Redis for caching
Firebase push notifications

3. Application Roles
   The system contains two main roles.
   3.1 Customer
   Customers are guests who visit venues and scan fiscal receipts to earn loyalty points.
   Customers can:
   scan fiscal receipts
   earn points
   share points with friends
   track progress
   claim rewards

3.2 Venue
Venues are hospitality businesses such as:
cafes
restaurants
bars
fast food restaurants
taverns
Venues can:
create loyalty rules
configure point formulas
create rewards
manage promotions
view analytics

4. Loyalty System
   4.1 Receipt Scanning
   Customers scan the QR code printed on a fiscal receipt.
   The QR code usually redirects to a verification page from the Serbian Tax Administration.
   The system extracts:
   tax_id (PIB)
   receipt_issue_time
   receipt_validity
   receipt_amount
   receipt_id

These values are used to calculate loyalty points.
Duplicate receipt scanning must be prevented. Thats done by backend.

4.2 Points Calculation
Each venue can define its own points formula.
Example formulas:
points = bill_amount * multiplier
Example:
points = bill_amount * 0.1
Alternative formula:
points = floor(bill_amount / 100)
Each venue must configure:
points_formula_type
points_multiplier
points_ratio

4.3 Sharing Points With Friends
Users may share points earned from a receipt with friends.
Rules:
points may be divided between multiple users
sharing must occur within a limited time window
receipt points cannot be claimed twice
Must use location for app, so users are nearby so its something like autentification
Example:
receipt amount: 2000 RSD
points earned: 200
shared between 4 friends
each receives 50 points

4.4 Rewards
Venues define rewards.
Example rewards:
Free fries
Free coffee
Free dessert
10% discount
Each reward contains:
reward_id
venue_id
reward_name
points_required
reward_description
reward_image
Customers can claim rewards when the required points are reached.

5. Promotions and Campaigns
   Venues can configure promotional campaigns.
   Example promotions:
   Double points on weekends
   Happy hour rewards
   Seasonal campaigns
   Each promotion contains:
   promotion_name
   start_date
   end_date
   points_multiplier
   description

6. Authentication
   Users authenticate using:
   Social login
   Supported providers:
   Google account
   Apple ID
   Optional fallback:
   email + JWT authentication
   Authentication flow:
   login -> backend verification -> JWT token issued
   JWT token is used for all authenticated API requests.

7. Mobile Application Screens
   The application contains the following screens.
   7.1 Login Screen
   Features:
   Google login
   Apple ID login

7.2 Home Screen
Displays a list of participating venues.
Similar concept to Wolt-style venue browsing.
Each venue card contains:
venue name
logo
promotion description
distance

7.3 Search Screen
Search venues using filters:
venue name
city
category
promotion type
Users can browse all partner venues.

7.4 Scan Screen
Camera interface for scanning receipt QR codes.
After scanning:
receipt verification page is opened
receipt data is extracted
loyalty points are calculated
points are assigned to the user

7.5 Progress Screen
Shows loyalty progress per venue.
Example:
Restaurant A — 120 points
Cafe B — 80 points
Fast Food C — 45 points
Displays progress toward rewards.

7.6 Profile Screen
User profile information:
name
email
profile picture
total points
claimed rewards

7.7 Friends Screen
Features:
friends list
add friend
share points
see shared points history

8. Bottom Navigation Menu
   All screens except the scan screen include a fixed bottom navigation bar.
   Navigation items:
   Home
   Search
   Scan
   Progress
   More
   The More menu contains:
   Profile
   Friends

9. Venue Management Features
   Venues must have management capabilities.
   Required functionality:
   create promotions
   create rewards
   set point formula
   view analytics
   track customer engagement

10. Fraud Prevention - done by backend
    The system must prevent abuse.
    Rules:
    each receipt can be used only once
    duplicate scans are blocked
    receipt id is stored in database

