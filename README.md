# Nashville-Housing-Data-Cleanup-SQL
<section>
<h1>Why Cleanup?</h1>
<p>This repository contains a SQL query created to clean up and make the Nashville housing data more usable in a few ways. 
I didn't perform any "drilling down" on the data to extract any type of analysis, I just cleaned it at this time to make it more usable for future projects if I feel inclined.
</br>
  <h2>Operations Performed</h2>
  After reviewing the data (a crucial step) I identified several areas where the data could be improved to make it easier to work with in the future.
<ol>
  <li>
    Covert SaleDate to include a column using "Date" type in addition to "Datetime". 
  </li>
  <li>
    Some entries have a missing information of Property Address where redundant information makes it possible to "fill in the blank:.
  </li>
  <li>
    Seperate the address attribute into component pieces using parcing. This is performed on PropertyAddress and OwnAddress attributes. Adding a total of 5 columns with discrete information of address, city and state.
  </li>
  <li>
    Make data entry consistent across "SoldAsVacant" column. Which includes entries of "N" and "No" and "Y" and "Yes". This is normalized across the data to be "Yes" and "No".
  </li>
  <li>
    Removing duplicate entries. There are some instances where a UniqueID is accompanied by identical ParcelId, PropertyAddress, SalePrice, SaleDate, LegalReference, (etc.) these duplicates are removed from the dataset.
  </li>
  <li>
    Unused or redundant columns are removed from the data. (I would not normally completely DELETE columns however this personal project work and it is allowable since the columns being removed have the data replicated in other areas). OwnerAddress has been parsed into SplitOwnerAddress, SpltOwnerCity, SplitOwnerState, therefore OwnerAddress will not be used and the data has been preserved. So we can save some processing power by deleting it. 
  </li>
</p>
</section>
