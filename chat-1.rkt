;;; A simple chatbot
;;; Author:    Naomi Campbell

;;; We'll use the random function implemented in Racket
;;; (random k) returns a random integer in the range 0 to k-1
(#%require (only racket/base random))

;;; some input and output helper functions

;;; prompt:  prompt the user for input
;;; return the input as a list of symbols
(define (prompt)
   (newline)
   (display "i'm all ears >>>")
   (read-line))

;;; read-line: read the user input till the eof character
;;; return the input as a list of symbols
(define (read-line)
  (let ((next (read)))
    (if (eof-object? next)
        '()
        (cons next (read-line)))))

;;; output: take a list such as '(how are you?) and display it
(define (output lst)
       (newline)
       (display (to-string lst))
       (newline))

;;; to-string: convert a list such as '(how are you?)
;;; to the string  "how are you?"
(define (to-string lst)       
  (cond ((null? lst) "")
        ((eq? (length lst) 1) (symbol->string (car lst)))
        (else (string-append (symbol->string (car lst))
                              " "
                             (to-string (cdr lst))))))


;;;  main function
;;;  usage:  (chat-with 'your-name)

(define (chat-with name)
  (output (list 'hi name))
  (chat-loop name))

;;; chat loop
(define (chat-loop name)
  (let ((input (prompt))) ; get the user input
    (if (eqv? (car input) 'bye)
        (begin
          (output (list 'bye name))
          (output (list 'have 'a 'great 'day!)))
        (begin
	  (reply input name)
          (chat-loop name)))))


;;; your task is to fill in the code for the reply function
;;; to implement rules 1 through 11 with the required priority
;;; each non-trivial rule must be implemented in a separate function
;;; define any helper functions you need below
(define (reply input name)
    (cond((do-can-etc? input) (do-can-etc-resp input name))
       ((special-topic? input) (special-topic-resp input name))
       ((why? input) (output '(why not?)))
       ((how? input) (output (pick-random how-response)))
       ((what? input) (output (pick-random what-response)))
       ((other-question? input) (output (pick-random other-response)))
       ((because? input) (output '(is that the real reason?)))
       ((need-think-etc? input) (need-think-etc-resp input))
       ((i-no-too? input) (i-no-too-resp input))
       ((verb? input) (verb-resp input))
       (else (output (pick-random generic-response))))) ;rule 11 has been implemented for you

;;; pick one random element from the list choices
(define (pick-random choices)
  (list-ref choices (random (length choices))))

;;; generic responses for rule 11
(define generic-response '((that\'s nice)
                           (good to know)
                           (can you elaborate on that?)
                           (that's not interesting)
                           (you\'re not funny)
                           (hahaha)))

;;; generic responses for rule 4
(define how-response '((why do you ask?)
                           (how would an answer to that help you?)
                           (why can\'t you figure it out for yourself?)
                           (how should I know?)))

;;; generic responses for rule 5
(define what-response '((what do you think?)
                       (why do you ask?)
                       (why would you ask that? get out of my way)))

;;; generic responses for rule 6
(define other-response '((i don\'t know)
                           (i have no idea)
                           (i have no clue)
                           (maybe)
                           (yawn)))

;;;pronouns
(define pronouns '(i you am are my your me you))

;;verbs
(define verbs '(tell give say eat smell hear write dance))

;;;special topics
(define special-topics '(music family friends mom dad brother sister girlfriend boyfriend children son daughter child wife husband home dog cat pet))

(define num-eight '(need think have want))

(define num-one '(do can will would))






;;;pattern checking functions
;;return true or false for all functions
(define (do-can-etc? l)
  (if (null? l) #f
       (and (in? (car l) num-one) (is-question? l))))

(define (special-topic? l)
 (cond((null? l) #f)
       ((in? (car l) special-topics) #t)
       (else (special-topic? (cdr l)))))

(define (why? l)
  (if (null? l) #f (and (equal? (car l) 'why) (is-question? l))))

(define (how? l)
  (if (null? l) #f (and (equal? (car l) 'how) (is-question? l))))

(define (what? l)
  (if (null? l) #f (and (equal? (car l) 'what) (is-question? l))))

(define (other-question? l)
  (cond((null? l) #f)
       ((is-question? l) #t)
       (else #f)))

(define (because? l)
  (cond((null? l) #f)
       ((in? 'because l) #t)
       (else #f)))

(define (need-think-etc? l)
  (if (null? l) #f)
       (let (
             (second (cdr l))
             )
         (if (and (equal? (car l) 'i) (in? (car second) num-eight)) #t #f)))

(define (i-no-too? l)
  (cond((null? l) #f)
       ((and (equal? (car l) 'i) (not (equal? (get-last-element l) 'too))) #t)
       (else #f)))

(define (verb? l)
  (cond((null? l) #f)
       ((in? (car l) verbs) #t)
       (else #f)))


;;;functions for returning result based on pattern

(define (do-can-etc-resp l name)
  (let(
       (a (append '(no) (list name 'i) (list (list-ref l 0) 'not) (change-all-pronouns (remove-question (list-tail l 2)))))
       (b (append '(yes i) (list (list-ref l 0))))
      )
    (output (pick-random (list a b)))))

(define (special-topic-resp l name)
  (output (append '(tell me more about your) (pick-topic l) (list name))))

(define (because-resp)
  (output '(is that the real reason?)))


(define (need-think-etc-resp l)
  (let
      (
       (w (symbol->string (list-ref l 1)))
       (tail (list-tail l 2))
      )
  (output (make-question (append '(why do you) (list (string->symbol w)) (change-all-pronouns tail))))))



(define (i-no-too-resp l)
  (output (append '(i) (cdr l) '(too))))

(define (verb-resp l)
  (output (append '(you) l)))




;;;helper functions from hw3
(define (set s)
  (cond((null? s) '())
       ((in? (car s)(cdr s)) (set(cdr s)))
       (else (cons (car s) (set (cdr s))))))

(define (in? e s)
  (cond((null? s) #f)
       ((equal? e(car s)) #t)
       (else (in? e (cdr s)))))

(define (intersection s1 s2)
  (cond ((or (null? s1) (null? s2)) '())
        ((in? (car s1) s2) (cons (car s1) (intersection (cdr s1) s2)))
        (else (intersection (cdr s1) s2))))

(define (disjoint? s1 s2)
  (cond ((null? (intersection s1 s2)) #t)
        (else #f)))







;;;self-implemented helper functions mentioned in slides

;;;get-special-topics: get a list of special topics in the list
;;;return list of special topics in the list
(define (get-special-topics l)
  (cond((null? l) '())
       ((in? (car l) special-topics) (cons (car l) (get-special-topics (cdr l))))
       (else (get-special-topics (cdr l)))))

;;;pick-topic: picks a random special topic in the list
(define (pick-topic l)
  (let
      (
       (t (get-special-topics l))
      )
  (if (null? (cdr t)) t (pick-random t))))

;;get-last-element: get the last element
;;return the last element in list
(define (get-last-element l)
  (if  (null? (cdr l))
       (car l)
       (get-last-element (cdr l))))

;;list-without-last: get the list without the last element
;;return input list without the last element
(define (list-without-last l)
  (if (null? (cdr l))
      '()
      (cons (car l)(list-without-last (cdr l)))))

;;remove-question: remove question mark from last symbol of a list of symbols
;;return the list without the question mark
(define (remove-question l)
    (let
      (
        (s (symbol->string (get-last-element l)))
      )
       (if (equal? (string-ref s (- (string-length s) 1)) #\?)
           (append (list-without-last l) (list (string->symbol (substring s 0 (- (string-length s) 1))))))) 
)

;;is-question: check whether input is a question
;;return #t if yes, #f if no
(define (is-question? l)
    (let((s (symbol->string (get-last-element l))))
       (if (equal? (string-ref s (- (string-length s) 1)) #\?) #t #f))
)


;;append-question: add ? to a symbol
;;return the symbol with a question mark appended to the end
(define (append-question e)
  (let
      (
        (s (symbol->string e))
      )
      (string->symbol (string-append s "?"))))

;;make-question: make a list a question
;;appends question mark to end of list
(define (make-question l)
  (let
      (
        (s (symbol->string (get-last-element l)))
      )
      (append (list-without-last l) (list (string->symbol (string-append s "?"))))))


;;change-pronoun: a function to change individual pronouns
;;return the exchanged pronouns
(define (change-pronoun e)
  (cond((eq? e 'i) 'you)
       ((eq? e 'your) 'my)
       ((eq? e 'am) 'are)
       ((eq? e 'me) 'you)
       ((eq? e 'my) 'your)
       ((eq? e 'you) 'me)
       (else e))
)  

;;change-all-pronouns: a function to change all pronouns in a sentence
;;return a list with all pronouns changed
(define (change-all-pronouns l)
  (cond((null? l) '())
       ((in? (car l) pronouns) (cons (change-pronoun (car l)) (change-all-pronouns (cdr l))))
       (else (cons (car l) (change-all-pronouns (cdr l)))))
)
