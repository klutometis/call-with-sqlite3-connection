(module
 call-with-sqlite3-connection
 (call-with-sqlite3-connection)

 (import scheme chicken)

 (use sqlite3)

 (define default-timeout (make-parameter 2000))

 (define (open-database/timeout database timeout)
   (let ((handler (make-busy-timeout timeout)))
     (let ((connection (open-database database)))
       (set-busy-handler! connection handler)
       connection)))

 (define call-with-sqlite3-connection
   (case-lambda
    ((database procedure)
     (call-with-sqlite3-connection database procedure (default-timeout)))
    ((database procedure timeout)
     (dynamic-wind
         (lambda () (set! database
                          (open-database/timeout database timeout)))
         (lambda () (procedure database))
         (lambda () (finalize! database #t)))))))

