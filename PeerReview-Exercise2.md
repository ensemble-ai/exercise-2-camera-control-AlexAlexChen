# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Keanu Chau
* *email:* kechau@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera correctly locks into the position of the ball. Visual cross in the center of the screen exists. There is an extra cross and box at first, but when you cycle back to the camera it disappears. An attempt was made to clear previous drawings.

___
### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Auto-scroll functionality doesn't work as expected. Visual camera logic is wrong and doesn't follow the camera or ball. There is a frame box that can be seen but it is directly drawn into the environment, so it will move out of frame when the user moves the ball. The ball is not pushed at anytime by autoscroller unless moved by the user.

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera correctly approaches the ball's position at a set speed. Visual camera logic works as expected. There are extra visual camera crosses if you toggle the visual camera logic.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Leash distance is not respected in the camera. The camera does not lead in the direction the ball is moving to. The ball will go outside the frame and after it stops, the camera catches up to the ball. This seems like a stage 3 camera since the camera catches up to the ball once it stops, but the leash functionality doesn't work.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
The ball is out of the frame. The visual camera logic is there but the ball isn't in the frame. The code seems like an attempt to solve the problem but nothing is working except the visual camera logic box. The visual camera logic box also gets distorted as the user moves.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
* [Didn't surround function definitions with 2 blank lines](https://github.com/ensemble-ai/exercise-2-camera-control-AlexAlexChen/blob/c6f8548179ed8d01cbf9a04b63f769f018f6e86b/Obscura/scripts/camera_controllers/stage1.gd#L11)
* [Script file names are not snake case]
* [Known variable types should be statically typed](https://github.com/ensemble-ai/exercise-2-camera-control-AlexAlexChen/blob/c6f8548179ed8d01cbf9a04b63f769f018f6e86b/Obscura/scripts/camera_controllers/stage2.gd#L28)
* [Prefer to use not, and, or rather than &&, ||, !](https://github.com/ensemble-ai/exercise-2-camera-control-AlexAlexChen/blob/c6f8548179ed8d01cbf9a04b63f769f018f6e86b/Obscura/scripts/camera_controllers/stage3.gd#L16)

#### Style Guide Exemplars ####
* [Whitespace is immaculate: All comments correctly spaced](https://github.com/ensemble-ai/exercise-2-camera-control-AlexAlexChen/blob/c6f8548179ed8d01cbf9a04b63f769f018f6e86b/Obscura/scripts/camera_controllers/stage3.gd#L24)

___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
* Overall, I see no best practices infractions except the ones listed in style guide infractions. One thing I noticed especially is how the code for multiple stages of the project that were not 'Perfect' had comments that seemed to be an attempt to solve the problem. However, this code wouldn't work as expected in multiple stages, so testing should've been better.
#### Best Practices Exemplars ####
* The code is very well commented even if some of it didn't function as expected. All the whitespace is really good, and code isn't hard to follow.