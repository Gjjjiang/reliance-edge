/*             ----> DO NOT REMOVE THE FOLLOWING NOTICE <----

                  Copyright (c) 2014-2021 Tuxera US Inc.
                      All Rights Reserved Worldwide.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; use version 2 of the License.

    This program is distributed in the hope that it will be useful,
    but "AS-IS," WITHOUT ANY WARRANTY; without even the implied warranty
    of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
/*  Businesses and individuals that for commercial or other reasons cannot
    comply with the terms of the GPLv2 license must obtain a commercial
    license before incorporating Reliance Edge into proprietary software
    for distribution in any form.

    Visit https://www.tuxera.com/products/reliance-edge/ for more information.
*/
/** @file
    @brief Implements assertion handling.
*/
#include <redfs.h>

#if REDCONF_ASSERTS == 1

#include <stdio.h>

#undef NDEBUG  /* Ensure assert() is enabled since REDCONF_ASSERTS is true. */
#include <assert.h>


/** @brief Invoke the native assertion handler.

    @param pszFileName  Null-terminated string containing the name of the file
                        where the assertion fired.
    @param ulLineNum    Line number in @p pszFileName where the assertion
                        fired.
*/
void RedOsAssertFail(
    const char *pszFileName,
    uint32_t    ulLineNum)
{
  #if REDCONF_OUTPUT == 1
    /*  pszFileName should never be NULL, but check just in case.
    */
    fprintf(stderr, "Assertion failed in \"%s\" at line %u\n",
        (pszFileName == NULL) ? "" : pszFileName, (unsigned)ulLineNum);
  #else
    (void)pszFileName;
    (void)ulLineNum;
  #endif

    assert(false);
}

#endif

