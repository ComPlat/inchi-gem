#ifndef INCHI_H_
#define INCHI_H_

#include <string>

typedef std::vector<std::string> MolVect;

struct ExtraInchiReturnValues {
  int returnCode;
  std::string messagePtr;
  std::string logPtr;
  std::string auxInfoPtr;  // not used for InchiToMol
};

/* options: space-delimited;
   each is preceded by '/' or '-' depending on OS and compiler */
std::string molfileToInchi(const std::string& mol,
  ExtraInchiReturnValues& rv, const char* options = NULL);
std::string InchiToInchiKey(const std::string& inchi);

#endif /* INCHI_H_ */
