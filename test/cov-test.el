(load-file "cov.el")

(require 'cov)

;; cov--keep-line?
(ert-deftest cov--keep-line--test ()
  (should-not (cov--keep-line? "        -:   22:        ")))

(ert-deftest cov--keep-line--block-test ()
  (should-not (cov--keep-line? "        1:   21-block  0")))

(ert-deftest cov--keep-line--executed-test ()
  (let ((line "        6:   24:        "))
    (should (cov--keep-line? line))
    (should (equal (match-string 1 line) "6"))
    (should (equal (match-string 2 line) "24"))))

(ert-deftest cov--keep-line--not-executed-test ()
  (let ((line "    #####:   24:        "))
    (should (cov--keep-line? line))
    (should (equal (match-string 1 line) "#####"))
    (should (equal (match-string 2 line) "24"))))

;; cov--locate-coverage-postfix
(ert-deftest cov--locate-coverage-postfix-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage-postfix path "test" "." ".gcov"))
         (expected (file-truename (format "%s/test.gcov" path))))
    (should (equal
             actual
             expected))))

(ert-deftest cov--locate-coverage-postfix---subdir-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage-postfix path "test" "../test" ".gcov"))
         (expected (file-truename (format "%s/test.gcov" path))))
    (should (equal
             actual
             expected))))

(ert-deftest cov--locate-coverage-postfix--wrong-subdir-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage-postfix path "test" "wrong-subdir" ".gcov")))
    (should (equal
             actual
             nil))))

(ert-deftest cov--locate-coverage-postfix--wrong-postfix-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage-postfix path "test" "." ".wrong-postfix")))
    (should (equal
             actual
             nil))))

;; cov--locate-coverage-path
(ert-deftest cov--locate-coverage-path-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage-path path "test" "."))
         (expected (cons (file-truename (format "%s/test.gcov" path)) 'gcov)))
    (should (equal
             actual
             expected))))

(ert-deftest cov--locate-coverage-path---subdir-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage-path path "test" "../test"))
         (expected (cons (file-truename (format "%s/test.gcov" path)) 'gcov)))
    (should (equal
             actual
             expected))))

(ert-deftest cov--locate-coverage-path--wrong-subdir-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage-path path "test" "wrong-subdir")))
    (should (equal
             actual
             nil))))

;; cov--locate-coverage
(ert-deftest cov--locate-coverage-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage (format "%s/%s" path "test")))
         (expected (cons (file-truename (format "%s/test.gcov" path)) 'gcov)))
    (should (equal
             actual
             expected))))

(ert-deftest cov--locate-coverage---wrong-file-test ()
  (let* ((path test-path)
         (actual (cov--locate-coverage (format "%s/%s" path "wrong-file"))))
    (should (equal
             actual
             nil))))
