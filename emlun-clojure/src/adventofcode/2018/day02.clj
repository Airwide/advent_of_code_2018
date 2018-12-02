(ns adventofcode.2018.day02)

(defn counts [coll]
  (reduce
    (fn [counts c]
      (update counts c #(inc (or % 0)))
    )
    {}
    coll))

(defn solve-a [lines]
  (->> lines
    (map (comp vals counts))
    (map (fn [counts]
      [
        (if (some #(= 2 %) counts) 1 0)
        (if (some #(= 3 %) counts) 1 0)
      ]))
    (reduce #(map + %1 %2))
    (apply *)
  ))

(defn without-index [i coll]
  (let [[head tail] (split-at i coll)]
    (str (apply str head) (apply str (rest tail)))
  ))

(defn nonunique [coll]
  (->> coll
    (counts)
    (filter #(< 1 (second %)))
    (map first)
  ))

(defn without-each [coll]
  (map
    #(without-index % coll)
    (take (count coll) (iterate inc 0))
  ))

(defn only [coll]
  { :pre [(= 1 (count coll))] }
  (first coll))

(defn solve-b [lines]
  (->> lines
    (map without-each)
    (apply map vector)
    (mapcat nonunique)
    (only)
  ))

(defn run [input-lines & args]
  { :A (solve-a input-lines)
    :B (solve-b input-lines)
  }
)
