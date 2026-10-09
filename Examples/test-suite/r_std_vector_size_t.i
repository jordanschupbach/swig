%module r_std_vector_size_t

%include <std_vector.i>

%template(SizeVector) std::vector<size_t>;

%inline %{
std::vector<size_t> make_sizes() {
  std::vector<size_t> v;
  for (size_t i = 1; i <= 3; ++i)
    v.push_back(i * 10);
  return v;
}

size_t sum_sizes(const std::vector<size_t> &v) {
  size_t sum = 0;
  for (size_t i = 0; i < v.size(); ++i)
    sum += v[i];
  return sum;
}

size_t sum_sizes_by_value(std::vector<size_t> v) {
  return sum_sizes(v);
}

%}
