#lang racket
(define (atom? x)
  (and (not (pair? x)) (not (null? x))))

(define rember
  (lambda (a lat)
    (cond
      ((null? lat) (quote()))
      ((eq? (car lat) a)(cdr lat))
      (else (cons(car lat)
                 (rember a (cdr lat)))))))

(define sum
  (lambda (list)
    (cond
      ((null? list) 0)
      (else (+ (car list)(sum (cdr list)))))))


