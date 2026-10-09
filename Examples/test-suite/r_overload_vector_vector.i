%module r_overload_vector_vector

%include <std_vector.i>

%template(VectorDouble) std::vector<double>;
%template(VectorVectorDouble) std::vector<std::vector<double> >;
%template(VectorInt) std::vector<int>;
%template(VectorVectorInt) std::vector<std::vector<int> >;

// The overloads make the R wrapper dispatch on the argument type.
%inline %{
int count_rows(const std::vector<std::vector<double> > &vv) { return (int)vv.size(); }
int count_rows(double) { return -1; }

int count_int_rows(const std::vector<std::vector<int> > &vv) { return (int)vv.size(); }
int count_int_rows(int) { return -1; }
%}
