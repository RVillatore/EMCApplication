#!/bin/bash
# fix_python3.sh

# Fix persistence.py
sed -i 's/print >> sys.stderr,''.join(args)/print(''.join(args), file=sys.stderr)/g' lib/python/gladevcp/persistence.py
sed -i 's/print ''.join(args)/print(''.join(args))/g' lib/python/gladevcp/persistence.py
sed -i 's/except Exception,msg:/except Exception as msg:/g' lib/python/gladevcp/persistence.py
sed -i 's/except (IOError, TypeError,UselessIniError),msg:/except (IOError, TypeError,UselessIniError) as msg:/g' lib/python/gladevcp/persistence.py
sed -i 's/if co_map.has_key(typename):/if typename in co_map:/g' lib/python/gladevcp/persistence.py

# Fix popupkeyboard.py
sed -i 's/except ImportError,msg:/except ImportError as msg:/g' lib/python/popupkeyboard.py

echo "Python 3 fixes applied"
