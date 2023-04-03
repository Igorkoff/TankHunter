# Tank Hunter – Final Year Project @ TU Dublin

### Mobile Application for Armoured Fighting Vehicles Detection

<p align='justify'>The purpose of this project is to create a cross-platform mobile application to allow loyal citizens to assist the Armed Forces, the Main Directorate of Intelligence and the Security Service of Ukraine in gathering information regarding the movements of enemy military columns and supply convoys, while enhancing the quality of data obtained, enforcing security, and improving user experience in comparison to some of the existing solutions.</p>

<p align='justify'>Tank Hunter is an application that will be developed as an outcome of this project. It will provide users with all the tools necessary to take an image of enemy armoured fighting vehicles and upload alongside geolocation and other useful information. Prior to being uploaded, the image will be validated in the background using deep learning algorithms for presence of military vehicles. As a result, having some preliminary information regarding armoured fighting vehicles detected will also facilitate workload for military analysts.
</p>

### Technologies:
* Flutter
* Hive
* Firebase
* Google ML Kit
* Google Vertex AI

## Functionality Overview

### Report the Enemy

<p align='justify'>This is the most important part of this project and allows users to report enemy vehicles. The page has a button to take an image from the camera. Upon taking a photo and writing an optional comment, the application saves the current location and passes the photo to the image classification model.
</p>

<p align='justify'>We have created a custom dataset of about 7000 images of armoured fighting vehicles used in Russian Army. With this dataset and Google Vertex AI platform we trained a custom image classification model which has an average precision of 95%. This model is capable of quick and accurate validation of the photo that user takes.
</p>

<p align='justify'>If at least one type of AFV is present in the image, the report is ready to be uploaded. If internet is available, image and report details are uploaded to the Firebase. If internet is not available, the image is saved in local storage and the path to the image along with report details, including image classification model output is saved in Hive to allow user to upload the report later when they have reliable internet connection. 
</p>

<p align='justify'>Reports are stored for no more than 12 hours, because the situation on the frontline is changing rapidly and there is not much use from the old intelligence reports. User can view the list of pending reports on a separate page and, if internet is available, upload all pending reports. User can also delete a report from pending reports, for example, if they decided that there are similar reports from the same area.
</p>

<p float='left'>
<img width="32%" alt="create_report_page" src="https://user-images.githubusercontent.com/59791908/229475390-9debbf83-3c7b-4119-add8-b91db559048a.png">
<img width="32%" alt="pending_reports_page" src="https://user-images.githubusercontent.com/59791908/229476154-d2740ff5-40dc-4226-a17d-0efaeb1821d8.png">
</p>

### Awards System

<p align='justify'>There is an achievements system in a form of virtual medals to keep user’s morale high: the more verified reports come from the user, the more prestigious medals and orders they get. This information can, for example, be used to issue real awards after the war is over. User can view their awards on a separate page within the application.
</p>

<img width="32%" alt="awards_page" src="https://user-images.githubusercontent.com/59791908/229479698-45d78e89-0772-4a6f-98d1-6871c026cc4a.png">

### Russian Losses

<p align='justify'>User can see the numbers of the Russian Armed Forces and the so-called DPR/LPR Militia losses within the application in case they are cut off from news outlets and media in Ukraine and it can also act as a morale boost. The app updates statistics through an API. The data from the API is cached, so that information remains accessible for some time after the last successful API request even when there is no internet connection.
</p>

<img width="32%" alt="losses_page" src="https://user-images.githubusercontent.com/59791908/229480750-26e4c666-1c61-404f-bed8-7c65d5a453a4.png">

### User Authentication

<p align='justify'>Firebase is used for User Authentication. When user opens the application for the first time, they are required to register. They need to fill in their details, such as first name, last name, passport number, email address and password. Upon registration, user profile is created in Firebase.
</p>

<p align='justify'>Originally, it was planned that user only needs a passport number and a password to login. However, Firebase Authentication requires either a phone number or an email address. An advantage of this approach is that in case user forgot their password and wanted to reset it, the password reset link will be sent to their registered email and they can change their password there.
</p>

<p align='justify'>In case user is forced to hand over their device for a check by the enemy soldiers, it is recommended that they delete the application from their device, or at the very least, logout from the application. When they logout, all pending reports are deleted, removing traces of any spy activity.
</p>

<p float='left'>
<img width="32%" alt="login_page" src="https://user-images.githubusercontent.com/59791908/229483787-03e18a0c-6913-4f35-9754-db4988990212.png">
<img width="32%" alt="signup_page" src="https://user-images.githubusercontent.com/59791908/229484089-e89cfb00-3ba2-4e7c-8774-2ed52d66796c.png">
</p>

<p float='left'>
<img width="32%" alt="profile_page" src="https://user-images.githubusercontent.com/59791908/229484592-0cecc934-cb79-4848-beec-85064ec6b5db.png">
<img width="32%" alt="password_page" src="https://user-images.githubusercontent.com/59791908/229484753-55253302-4b1f-42ce-ab1f-448c638c048a.png">
</p>

## Future Plans

* Improve Classification Model / Introduce Object Detection
* Read NFC from Passports / Use Diia to Register
* Ukrainian Translations
* More Testing

