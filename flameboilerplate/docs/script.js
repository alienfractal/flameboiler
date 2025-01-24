document.addEventListener("DOMContentLoaded", function () {
    const containers = {
        menu_def : 'cnt_definitions',
        menu_evt_tbl : 'cnt_event_table',
        menu_story : 'cnt_story'
    };
// Attaching click event listeners to each nav item
document.querySelectorAll("nav a").forEach(function(navItem) {
    navItem.addEventListener("click", function(event) {
        event.preventDefault(); // Prevent the default anchor action
        
      // Hide all containers
      document.querySelectorAll(".container").forEach(container => {
        if (container.id !== 'menu_section') {
            container.style.display = 'none';
        }
      
    });

    // Extracting the target container ID from the clicked nav item
    const targetContainerId = containers[event.target.id];

    // Show the target container
    const targetContainer = document.getElementById(targetContainerId);
    if (targetContainer) {
        targetContainer.style.display = 'block';
    }
      
    });
});


    fetch("categories.json")
        .then(response => response.json())
        .then(data => {
            const container = document.getElementById("cnt_definitions");

            data.categories.forEach(category => {
                const categoryDiv = document.createElement("div");
                categoryDiv.className = "category";

                categoryDiv.innerHTML = `
                    <h2>${category.title}</h2>
                    <p><strong class="title">Definition:</strong> ${category.definition}</p>
                    <p><strong class="title">Focus:</strong> ${category.focus}</p>
                    <p><strong class="title">Example:</strong> ${category.example}</p>
                `;

                container.appendChild(categoryDiv);
            });
        })
        .catch(error => console.error("Error fetching category data:", error));
    // Your existing code for other functionalities


 

    fetch("eventstorm.json")
        .then(response => response.json())
        .then(data => {
            const tableBody = document.querySelector("#eventsTable tbody");
            let implementedYesCount = 0; // Initialize counter for tasks marked "Yes"
            let taskcount = 0;
            data.events.forEach((event, index) => {
                const row = document.createElement("tr");
                row.classList.add("category-" + event.CategoryID); // Add class based on CategoryID
                row.innerHTML = `
                    <td>${index}</td>
                    <td>${event.CategoryID}</td>
                    <td>${event.Category}</td>
                    <td>${event["Event Name"]}</td>
                    <td>${event.Trigger}</td>
                    <td>${event.Result}</td>
                    <td>${event.Notes}</td>
                `;
                row.appendChild(setLastColumn(event));
                tableBody.appendChild(row);
                  // Increment counter if the task is marked as "Yes"
                  if (event.Implemented === 'Yes') {
                    implementedYesCount++;
                }
                taskcount++;
                
            });
              // Append a summary row at the bottom
              appendSummaryRow(tableBody, implementedYesCount,taskcount);
        })
        .catch(error => console.error("Error fetching data:", error));

             // Hide all containers
      document.querySelectorAll(".container").forEach(container => {
        if (container.id !== 'menu_section' && container.id !== 'cnt_story') {
            container.style.display = 'none';
        }
      
    });
});

function appendSummaryRow(tableBody, count,total) {
    const summaryRow = document.createElement("tr");
    summaryRow.classList.add("category-6");
    let pct = Math.round((count / total) * 100);
    summaryRow.innerHTML = `
    <td> </td>
    <td> </td>
        <td>Total Implemented: </td>
        <td>${count} / ${total}</td>
        <td>${pct} %</td>
        <td>Todo: ${total - count} </td>
    `;
    tableBody.appendChild(summaryRow);
}

function setLastColumn(event){
 // Determine color for the Implemented column
 let implementedColor = '';
 if (event.Implemented === 'Yes') {
     implementedColor = '#6c8c50';
 } else if (event.Implemented === 'No') {
     implementedColor = '#a13d3b';
 }
 else if (event.Implemented === 'Wp') {
    implementedColor = '#e3d245';
}

 // Create cell for Implemented column with appropriate style
 const implementedCell = document.createElement("td");
 implementedCell.textContent = event.Implemented;
 implementedCell.style.background = implementedColor;

 return implementedCell;

}