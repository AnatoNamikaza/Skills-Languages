;;;; A Simple Natural Language Processing Example in Common Lisp
;;;; This code tokenizes and counts word occurrences in a text document.

;;;; Define a function to tokenize a text into words.
(defun tokenize(text)
  (let ((word-list (remove-if #'(lambda (x) (string= x "")) (split-sequence:split-sequence #\Space text))))
    (mapcar #'(lambda (word) (string-downcase word)) word-list)))

;;;; Define a function to count word occurrences.
(defun count-words(tokens)
  (let ((word-count (make-hash-table :test 'equal)))
    (dolist (word tokens)
      (if (gethash word word-count)
          (incf (gethash word word-count))
          (setf (gethash word word-count) 1)))
    word-count))

;;;; Read a text document from a file.
(defun read-text-from-file(filename)
  (with-open-file (stream filename :direction :input)
    (let ((text (with-output-to-string (out)
                  (loop for line = (read-line stream nil)
                        while line do (format out "~a " line)))))
      text))

;;;; Example usage: Analyze a text file.
(let ((filename "sample_text.txt"))
  (let ((text (read-text-from-file filename))
        (tokens (tokenize text))
        (word-count (count-words (tokenize text))))
    (format t "Total words: ~a~%" (length tokens))
    (format t "Word occurrences: ~a~%" word-count)))
