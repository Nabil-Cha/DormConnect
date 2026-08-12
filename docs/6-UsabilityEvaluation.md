# Usability Evaluation

## Heuristic Evaluation

We evaluated DormConnect using Nielsen’s 10 usability heuristics to systematically identify issues and opportunities for improvement. The app’s design is clean and minimal, with a consistent bottom navigation bar and intuitive labels that align with user expectations, supporting learnability for first-time users. Visibility of system status is maintained during navigation; however, we noticed the absence of explicit confirmation messages after actions like signing in or joining an activity, which can leave users uncertain about whether their action was successful.

On the sign-in screen, the modal requesting a username is clear and enables a fast start, yet the lack of a password may cause users to question the security of the login process. The Discover page displays activities in a clear and organized manner, allowing users to tap on cards to access detailed information. The creation modal, accessed via the “+” button, allows users to add activities or communities easily, but the absence of validation feedback when required fields are left empty could frustrate users. The Communities page effectively displays joined and available communities, supporting intuitive exploration and joining with a single tap. The Profile page allows easy management of preferences, though the logout feature could benefit from a confirmation dialog.

While the app’s core structure supports ease of use and task efficiency, it would benefit from additional feedback mechanisms, clearer error prevention, and accessibility considerations to improve the user experience.

---

## Accessibility Evaluation

Using the Accessibility Scanner on an Android device, we assessed DormConnect for accessibility. The app has a clear, uncluttered interface and appropriately sized touch targets, making it easy to use on mobile devices. However, we found that several buttons and icons lack semantic labels, which makes it difficult for users relying on screen readers to navigate the app effectively. Some UI elements may not meet recommended color contrast ratios, which could impact users with visual impairments.

Currently, the app does not support keyboard navigation, which may limit accessibility for tablet users or individuals using external keyboards. To enhance inclusivity, it would be beneficial to add semantic labels to all interactive elements, adjust color contrasts to meet WCAG standards, and implement keyboard navigation and focus management.

---

## Cognitive Walkthrough

We performed a cognitive walkthrough focusing on the workflows that a first-time user would follow. Signing in is straightforward as the app prompts the user for a username, which allows for quick entry into the app, but it may create confusion due to the absence of a password field. Upon entering the app, users are directed to the Home page, where they can view upcoming activities and navigate easily to view or join them.

On the Discover page, users can explore activities from their communities and join them by tapping on activity cards. This interaction is clear and supports easy task completion. Creating a new activity or community is facilitated by the prominently displayed “+” button. While the creation process is intuitive, the lack of immediate validation feedback for incomplete fields may cause confusion. The Communities page allows users to explore and join new communities with a single tap, while the Profile section provides a clear structure for managing settings such as notifications and themes.

Overall, users can complete essential tasks without significant barriers, but the app would benefit from improved feedback and clearer guidance in some areas.

---

## Thinking-Aloud Tests

Two think-aloud tests were conducted with student participants. The first participant, a 22-year-old frequent app user, found signing in quick but questioned the lack of a password. They navigated the Discover page with ease, joined activities without confusion, and found the process of creating a new activity intuitive but noted that there was no confirmation message after submission. They appreciated the app’s clean design and clear navigation during their 25-minute session.

The second participant, a 24-year-old with moderate technical skills, tested the app for 30 minutes and noted the ease of use throughout the core workflows, including signing in, joining activities, and creating a community. They also expressed concerns about the absence of validation messages when submitting forms with incomplete information and mentioned the desire for confirmation feedback after completing actions. Overall, both participants found the app modern and easy to navigate, highlighting minor areas for improvement related to feedback and user clarity.

---

## Synthesis of Findings

Through our evaluations, we identified several key findings that will guide improvements to DormConnect. We found that the lack of confirmation messages after actions such as signing in and joining activities leaves users unsure whether their action was successful. Users also expressed uncertainty about the security of the login process due to the absence of a password, indicating the need for either clarification of guest login functionality or the addition of a password field. The absence of validation feedback when submitting forms with missing required fields is a significant usability issue, as it may frustrate users who do not know why their submission is unsuccessful. Additionally, the lack of feedback after joining activities and communities was noted as a point of uncertainty for users.

From an accessibility perspective, the app would benefit from the addition of semantic labels to interactive elements to support screen reader users, adjustments to color contrasts to aid visually impaired users, and implementation of keyboard navigation for improved inclusivity. The absence of loading indicators during network-dependent actions was also identified as a minor issue that, if addressed, would enhance user experience by providing clear feedback that an action is being processed.

These findings will guide the next iteration of DormConnect, prioritizing the addition of feedback and confirmation messages, improving form validation, and enhancing accessibility features to ensure the app remains user-friendly and inclusive.

---

## Reflection

Conducting this usability evaluation provided valuable insights into DormConnect’s strengths and areas for improvement. By systematically applying heuristic evaluation, we were able to identify areas where the app performs well, such as consistency and ease of navigation, while also uncovering issues related to feedback and validation. The cognitive walkthrough allowed us to experience the app from the perspective of a new user, confirming that core workflows are intuitive while highlighting areas where clearer guidance would enhance the experience.

The think-aloud tests offered real user perspectives, emphasizing the importance of providing feedback and confirmation to users during key interactions. Finally, the accessibility evaluation reminded us of the importance of designing for all users, including those relying on screen readers or requiring high-contrast interfaces.

Overall, this evaluation process has highlighted the value of iterative testing and user-centered design in app development. We have learned that even small changes, such as adding confirmation messages or improving color contrast, can significantly enhance the user experience. This evaluation will guide our next steps in refining DormConnect, ensuring it is well-prepared for deployment and further user testing.

