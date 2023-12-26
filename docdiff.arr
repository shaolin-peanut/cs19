import lists as L
include math

fun dot_product(doc1, doc2) -> Number:
  sum(L.map2(_ * _, doc1, doc2))
end

fun overlap(doc1 :: List<String>, doc2 :: List<String>) -> Number:
  gdoc1 = L.sort(map(string-to-lower, doc1))
  gdoc2 = L.sort(map(string-to-lower, doc2))
  word_vector = L.sort(L.distinct(L.append(gdoc1, gdoc2)))
  doc1rep = word_vector.map(lam(elem): gdoc1.filter(lam(s): s == elem end).length() end)
  doc2rep = word_vector.map(lam(elem): gdoc2.filter(lam(s): s == elem end).length() end)
  #  sum(L.map2(_ * _, doc1rep, doc2rep)) / num-max(doc1rep.length() * doc1rep.length(), doc2rep.length() * doc2rep.length())
  dot_product(doc1rep, doc2rep) / num-max(
    num-sqr(num-sqrt(dot_product(doc1rep, doc1rep))),
    num-sqr(num-sqrt(dot_product(doc2rep, doc2rep))))
where:
 # these examples taken from the Examplar paper
  overlap([list: "welcome", "to", "Walmart"], 
    [list: "WELCOME", "To", "walmart"]) is-roughly 3/3
  overlap([list: "1", "!", "A", "?", "b"], 
    [list: "1", "A", "b"]) is-roughly 3/5
  overlap([list: "alakazam", "abra"],
    [list: "abra", "kadabra", "alakazam", "abra"]) is-roughly 2/4
  overlap([list: "a", "b"], [list: "c"]) is 0/3

  # epsilon test for roughnums
  epsilon = 0.001
  a = [list: "alakazam", "abra"]
  b = [list: "abra", "kadabra", "alakazam", "abra"]

  num-abs(overlap(a, b) - 2/4) <= epsilon is true
end
