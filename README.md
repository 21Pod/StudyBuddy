
# StudyBuddy

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
College can be a stressful environment to make friends and especially peers to study with, and this is a problem that this app attempt alleviate. This is a location sharing service aimed at finding study buddies for your college courses, with a map and profile interface akin to that of Snapchat. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social/ Location Sharing / Maps
- **Mobile:** iOS application, using location. Mobile first experince
- **Story:** Allows college students to find study mates in similar courses through location sharing
- **Market:** College/ University students on their respective campuses; students who want to find study buddies/ make friends taking the same classes will enjoy this app
- **Habit:** Users can open the app and make their location public when they are open for other users to join them during a study session.
- **Scope:** Very focused on location sharing in the initial stage. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can see the app logo and open the app from the home page
* User can login (based on school email)
* User can share the location
* User can choose what class they want to share their location with
* User can see everyone who are sharing their location and see their basic profile (user can filter based on classes)
* User can see their profile (current classes, bio, privacy settings, etc)
* Refresh page button
* User can stop sharing location



**Optional Nice-to-have Stories**

* Chat function
* Directions
* Automatically update your current classes each term
* User can set a study time, after which automatically stop sharing location


### 2. Screen Archetypes

* Login
   * Enter school email 
   * Manually enter your current classes
* Home
   * User can share the location
   * User can choose what class they want to share their location with
* Friends
    * User can see everyone who are sharing their location and see their basic profile (user can filter based on classes)
* Profile
    * User can see their profile (current classes, bio, privacy settings, etc)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home - your current location and option to share
* Friends - friends who are looking for study mates
* Profile - user's basic infromation

**Flow Navigation** (Screen to Screen)

* User can go to any screen using tabs

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/hvTgcZY.jpg" title="source: imgur.com" />

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
  * User Profile
  * Search
  * Chat
  * Annotated map 

### Models
 * Friends (count)
 * Location sharer
 * Classes
 * Bio (caption)
 * Coordinates


   | Property         | Type     | Description |
   | ---------------- | -------- | ------------|
   | friends          | Number   | number of likes for the post |
   | classes          | String   | List of classes that a student takes |
   | bio (caption)    | String   | bio fields made by the user |
   | coordiantes      | String   | PF Object using the PFGeoPoint |
   


### Networking
- get friends by clases
- get friends locations 

- ```swift
          // User's location
          let userGeoPoint = userObject["location"] as PFGeoPoint
          // Create a query for places
          var query = PFQuery(className:"PlaceObject")
          // Interested in locations near user.
          query.whereKey("location", nearGeoPoint:userGeoPoint)
          // Limit what could be a lot of points.
          query.limit = 10
          // Final list of objects
          placesObjects = query.findObjects()
         ```
- post specific room location (e.g., Builing Name, floor a, room 345)
- get/post infomation for friends profile (name, bio, profile photo, status)
- post coordiante location
- get friends enrolled classes
####Assingments
yeleaman: Parse Server
Aida: Logo Design for the app
