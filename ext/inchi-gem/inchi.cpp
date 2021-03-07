#include <string>
#include <inchi_api.h>
#include <cstring>
#include <vector>
#include <stack>
#include <set>
#include <queue>
#include <algorithm>
#include <iostream>

#include "inchi.h"

typedef std::pair<int, int> INT_PAIR;
typedef std::vector<INT_PAIR> INT_PAIR_VECT;

void fixOptionSymbol(const char* in, char* out) {
  unsigned int i;
  for (i = 0; i < strlen(in); i++) {
#ifdef _WIN32
    if (in[i] == '-') {
      out[i] = '/';

#else
    if (in[i] == '/') {
      out[i] = '-';

#endif
    } else {
      out[i] = in[i];
    }
  }
  out[i] = '\0';
}

std::string molfileToInchi(const std::string& molBlock,
  ExtraInchiReturnValues& rv, const char* options) {
  // create output
  inchi_Output output;
  memset((void*)&output, 0, sizeof(output));
  // call DLL
  std::string inchi;
  {
    char* _options = nullptr;
    if (options) {
      _options = new char[strlen(options) + 1];
      fixOptionSymbol(options, _options);
      options = _options;
    }

    int retcode = MakeINCHIFromMolfileText(molBlock.c_str(), (char*)options, &output);

    // generate output
    rv.returnCode = retcode;
    if (output.szInChI) {
      inchi = std::string(output.szInChI);
    }
    if (output.szMessage) {
      rv.messagePtr = std::string(output.szMessage);
    }
    if (output.szLog) {
      rv.logPtr = std::string(output.szLog);
    }
    if (output.szAuxInfo) {
      rv.auxInfoPtr = std::string(output.szAuxInfo);
    }

    // clean up
    FreeINCHI(&output);
    delete[] _options;
  }

  return inchi;
}

std::string InchiToInchiKey(const std::string& inchi) {
  char inchiKey[29];
  char xtra1[65], xtra2[65];
  int ret = 0;

  {
    ret = GetINCHIKeyFromINCHI(inchi.c_str(), 0, 0, inchiKey, xtra1, xtra2);
  }

  std::string error;
  switch (ret) {
    case INCHIKEY_OK:
      return std::string(inchiKey);
    case INCHIKEY_UNKNOWN_ERROR:
      error = "Unknown error";
      break;
    case INCHIKEY_EMPTY_INPUT:
      error = "Empty input";
      break;
    case INCHIKEY_INVALID_INCHI_PREFIX:
      error = "Invalid InChI prefix";
      break;
    case INCHIKEY_NOT_ENOUGH_MEMORY:
      error = "Not enough memory";
      break;
    case INCHIKEY_INVALID_INCHI:
      error = "Invalid input InChI string";
      break;
    case INCHIKEY_INVALID_STD_INCHI:
      error = "Invalid standard InChI string";
      break;
  }

  return std::string();
}
