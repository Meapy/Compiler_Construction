int main()
{
  char true_var = 5;
  int false_var = 0;
  return
    !(
      (true_var || fase_var) &&
      !(true_var && false_var) &&
      (true_var && !false_var) &&
      (true_var || false_var && false_var)
      ;
}

}

