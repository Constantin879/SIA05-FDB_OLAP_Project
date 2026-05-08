package org.j4di.access.views.userprofile;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface USERPROFILE_VIEW_Repository extends JpaRepository<USERPROFILE_VIEW, Long> {
    @Query(value = "SELECT * FROM default.usersprofile_view", nativeQuery = true)
    List<USERPROFILE_VIEW> get_USERPROFILE_VIEW();
}
