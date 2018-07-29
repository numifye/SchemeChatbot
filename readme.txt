Author: Naomi Campbell

A chatbot program in Scheme. Includes changing pronouns for responses (e.g. I becomes you, am becomes are, my becomes your) and several pattern checking functions.

Specs:
1. input form: (do|can|will|would) you ____?
	-options for randomly chosen response:
		-no <name> i (do|can|will|would) not __change person__
		-yes i (do|can|will|would)
2. input form: __(special topics)__
	-options for randomly chosen response:
		-tell me more about your (special topics)… <name>
3. input form: why ____?
	-options for randomly chosen response:
		-why not?
4. input form: how ____?
	-options for randomly chosen response:
		-why do you ask?
		-how would an answer to that help you?
5. input form: what ____?
	-options for randomly chosen response:
		-what do you think?
		-why do you ask?
6. input form: ____?
	-options for randomly chosen response:
		-i don’t know, i have no idea, i have no clue, maybe
7. input form: ____because____
	-options for randomly chosen response:
		-is that the real reason?
8. input form: i (need|think|have|want) ____
	-options for randomly chosen response:
		-why do you (need|think|have|want) __change person__?
9. input form: i ____ (last word is not too)
	-options for randomly chosen response:
		-i ____ too
10. input form: verb ____
	-options for randomly chosen response:
		-you verb ____
11. everything else
	-options for randomly chosen response:
		-good to know, that’s nice, can you elaborate on that?