(module
 call-with-connection
 (call-with-connection)

 (import scheme chicken)

 (use sqlite3)

 (define timeout 2000)

 (define (open-database/timeout database timeout)
   (let ((handler (make-busy-timeout timeout)))
     (let ((connection (open-database database)))
       (set-busy-handler! connection handler)
       connection)))

 (define call-with-connection
   (case-lambda
    ((database procedure)
     (call-with-connection database procedure timeout))
    ((database procedure timeout)
     (let ((database (open-database/timeout database timeout)))
       (dynamic-wind
           (lambda () #f)
           (lambda () (procedure database))
           (lambda () (finalize! database #t))))))))
