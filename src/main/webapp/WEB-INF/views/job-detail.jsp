<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${job.title} | TalentConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
</head>
<body>

    <!-- Header Navbar -->
    <jsp:include page="navbar.jsp" />

    <main class="container">
        <!-- Nút quay lại -->
        <a href="${pageContext.request.contextPath}/home" style="display: inline-flex; align-items: center; gap: 8px; margin-bottom: 24px; color: var(--text-muted); font-size: 14px; font-weight: 500;">
            <span>&larr;</span> Quay lại danh sách tin đăng
        </a>

        <!-- Hộp Thông Báo Lỗi / Thành Công từ Session -->
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger">${sessionScope.errorMsg}</div>
            <% session.removeAttribute("errorMsg"); %>
        </c:if>
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success">${sessionScope.successMsg}</div>
            <% session.removeAttribute("successMsg"); %>
        </c:if>

        <div style="display: grid; grid-template-columns: 1fr 400px; gap: 32px; align-items: start;">
            <!-- Keyword logic -->
            <c:set var="imgKeyword" value="concert,stage" />
            <c:set var="titleLower" value="${fn:toLowerCase(job.title)}" />
            <c:choose>
                <c:when test="${fn:contains(titleLower, 'guitar')}"><c:set var="imgKeyword" value="guitar" /></c:when>
                <c:when test="${fn:contains(titleLower, 'dj')}"><c:set var="imgKeyword" value="dj" /></c:when>
                <c:when test="${fn:contains(titleLower, 'ca sĩ') || fn:contains(titleLower, 'hát')}"><c:set var="imgKeyword" value="singer,vocal" /></c:when>
                <c:when test="${fn:contains(titleLower, 'trống') || fn:contains(titleLower, 'drum')}"><c:set var="imgKeyword" value="drummer,drums" /></c:when>
                <c:when test="${fn:contains(titleLower, 'piano') || fn:contains(titleLower, 'organ')}"><c:set var="imgKeyword" value="piano,keyboard" /></c:when>
                <c:when test="${fn:contains(titleLower, 'múa') || fn:contains(titleLower, 'dance')}"><c:set var="imgKeyword" value="dance,dancer" /></c:when>
                <c:when test="${fn:contains(titleLower, 'mc') || fn:contains(titleLower, 'dẫn chương trình')}"><c:set var="imgKeyword" value="microphone,host" /></c:when>
            </c:choose>

            <!-- Chi tiết công việc -->
            <div class="card ${param.highlight == 'true' ? 'highlight-pulse' : ''}" style="padding: 0; overflow: hidden;">
                <!-- Hero Banner -->
                <c:choose>
                    <c:when test="${not empty job.thumbnailUrl}">
                        <img src="${job.thumbnailUrl}" alt="Job Cover" style="width: 100%; height: 280px; object-fit: cover; border-bottom: 4px solid var(--primary);">
                    </c:when>
                    <c:otherwise>
                        <img src="https://loremflickr.com/1200/400/${imgKeyword}?random=${job.id}" alt="Job Cover" style="width: 100%; height: 280px; object-fit: cover; border-bottom: 4px solid var(--primary);">
                    </c:otherwise>
                </c:choose>
                
                <div style="padding: 40px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px;">
                        <div>
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <span style="font-size: 14px; font-weight: 600; color: var(--secondary); text-transform: uppercase;">${job.employerName}</span>
                            <button class="btn btn-secondary btn-sm" onclick="openChatWithUser(${job.employerId}, '${job.employerName.replace('\'', '\\\'')}')" style="padding: 4px 12px; font-size: 12px; border-radius: 12px; display: flex; align-items: center; gap: 4px;">
                                💬 Liên hệ
                            </button>
                        </div>
                        <h1 style="font-size: 32px; font-weight: 800; margin-top: 8px;">${job.title}</h1>
                    </div>
                </div>

                <div class="job-tags" style="margin-bottom: 32px;">
                    <c:if test="${not empty job.tags}">
                        <c:forEach items="${job.tags.split(',')}" var="tag">
                            <span class="tag" style="font-size: 14px; padding: 6px 16px;">🏷️ ${tag.trim()}</span>
                        </c:forEach>
                    </c:if>
                    <span class="tag tag-location" style="font-size: 14px; padding: 6px 16px;">📍 ${job.location}</span>
                    <span class="tag tag-salary" style="font-size: 14px; padding: 6px 16px;">
                        💰 <fmt:formatNumber value="${job.salary}" type="number"/> VNĐ
                    </span>
                    <span class="tag" style="font-size: 14px; padding: 6px 16px;">📅 Hạn nộp: <fmt:formatDate value="${job.deadline}" pattern="dd/MM/yyyy"/></span>
                </div>

                <h3 style="font-size: 20px; font-weight: 700; margin-bottom: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 8px;">Mô tả công việc / Show diễn</h3>
                <p style="line-height: 1.8; color: var(--text-muted); white-space: pre-line; margin-bottom: 32px; font-size: 15px;">${job.description}</p>

                <h3 style="font-size: 20px; font-weight: 700; margin-bottom: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 8px;">Yêu cầu đối với ứng viên</h3>
                <p style="line-height: 1.8; color: var(--text-muted); white-space: pre-line; font-size: 15px; margin-bottom: 32px;">${job.requirements}</p>

                <h3 style="font-size: 20px; font-weight: 700; margin-bottom: 16px; border-bottom: 1px solid var(--border-color); padding-bottom: 8px;">Đánh giá nhà tuyển dụng (${fn:length(employerReviews)})</h3>
                <c:choose>
                    <c:when test="${empty employerReviews}">
                        <p style="color: var(--text-muted); font-size: 15px;">Chưa có đánh giá nào cho nhà tuyển dụng này.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="reviews-list">
                            <c:forEach items="${employerReviews}" var="review" varStatus="status">
                                <div class="review-item ${status.index >= 5 ? 'hidden-review' : ''}" style="padding: 16px; border: 1px solid var(--border-color); border-radius: 8px; margin-bottom: 12px; background: rgba(255,255,255,0.02); ${status.index >= 5 ? 'display: none;' : ''}">
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                        <div style="font-weight: 600;">${review.reviewerName}</div>
                                        <div style="color: #f59e0b;">
                                            <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                        </div>
                                    </div>
                                    <p style="font-size: 14px; color: var(--text-muted); margin-bottom: 8px;">Dự án: ${review.jobTitle}</p>
                                    <p style="font-size: 15px; margin: 0; line-height: 1.6;">"${review.comment}"</p>
                                </div>
                            </c:forEach>
                            
                            <c:if test="${fn:length(employerReviews) > 5}">
                                <div style="text-align: center; margin-top: 16px;" id="showMoreContainer">
                                    <button id="btnShowMoreReviews" class="btn btn-secondary btn-sm" onclick="showMoreReviews()" style="background: transparent; border: 1px solid var(--border-color); color: var(--text-muted);">Xem thêm ${fn:length(employerReviews) - 5} đánh giá ▾</button>
                                </div>
                                <script>
                                    function showMoreReviews() {
                                        var hiddenReviews = document.querySelectorAll('.hidden-review');
                                        hiddenReviews.forEach(function(item) {
                                            item.style.display = 'block';
                                        });
                                        document.getElementById('showMoreContainer').style.display = 'none';
                                    }
                                </script>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>
            </div>

            <!-- Form nộp đơn ứng tuyển -->
            <div>
                <c:choose>
                    <c:when test="${sessionScope.user.roleName == 'Candidate' && hasApplied}">
                        <div class="card" style="text-align: center; padding: 40px; border-color: rgba(16, 185, 129, 0.3);">
                            <span style="font-size: 32px;">✅</span>
                            <h3 style="font-size: 18px; font-weight: 700; margin-top: 16px; color: var(--color-success);">Đã nộp đơn ứng tuyển</h3>
                            <p style="font-size: 14px; color: var(--text-muted); margin-top: 8px; margin-bottom: 24px;">Bạn đã nộp đơn ứng tuyển cho show diễn này. Vui lòng theo dõi trạng thái tại Dashboard cá nhân của bạn.</p>
                            <a href="${pageContext.request.contextPath}/candidate/dashboard" class="btn btn-secondary" style="width: 100%;">Xem lịch sử ứng tuyển</a>
                        </div>
                    </c:when>
                    <c:when test="${isExpired}">
                        <div class="card" style="text-align: center; padding: 40px;">
                            <span style="font-size: 32px;">⏰</span>
                            <h3 style="font-size: 18px; font-weight: 700; margin-top: 16px; color: var(--color-error);">Đã hết hạn nộp hồ sơ</h3>
                            <p style="font-size: 14px; color: var(--text-muted); margin-top: 8px;">Rất tiếc, tin tuyển dụng này đã đóng đăng ký vì đã qua hạn chót (<fmt:formatDate value="${job.deadline}" pattern="HH:mm dd/MM/yyyy"/>).</p>
                        </div>
                    </c:when>
                    <c:when test="${empty sessionScope.user}">
                        <div class="card" style="text-align: center; padding: 40px;">
                            <span style="font-size: 32px;">🔒</span>
                            <h3 style="font-size: 18px; font-weight: 700; margin-top: 16px;">Đăng nhập để ứng tuyển</h3>
                            <p style="font-size: 14px; color: var(--text-muted); margin-top: 8px; margin-bottom: 24px;">Bạn cần đăng nhập bằng tài khoản ứng viên để có thể ứng tuyển vào show diễn này.</p>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="width: 100%;">Đăng nhập ngay</a>
                        </div>
                    </c:when>
                    <c:when test="${sessionScope.user.roleName == 'Candidate'}">
                        <div class="card" style="padding: 32px;">
                            <h3 style="font-size: 20px; font-weight: 700; margin-bottom: 8px;">Nộp hồ sơ ứng tuyển</h3>
                            <form action="${pageContext.request.contextPath}/candidate/apply" method="POST" onsubmit="return validateApplicationForm()">
                                        <input type="hidden" name="jobId" value="${job.id}">
                                        
                                        <c:set var="cvList" value="${fn:split(profile.cvImages, ',')}" />
                                        <c:set var="firstCv" value="${not empty cvList ? cvList[0] : ''}" />
                                        <input type="hidden" id="resumeUrl" name="resumeUrl" value="${firstCv}">

                                        <!-- Thông báo nếu chưa có CV -->
                                        <div id="noCvMessage" style="color: var(--color-error); font-size: 13px; margin-bottom: 16px; ${empty profile.cvImages ? '' : 'display: none;'}">
                                            ⚠️ Bạn chưa tải lên CV nào. Vui lòng nhấn nút bên dưới để tải lên CV của bạn!
                                        </div>
                                        
                                        <!-- Danh sách CV chọn nhanh -->
                                        <div id="cvSelectionFormGroup" class="form-group" style="margin-bottom: 16px; ${empty profile.cvImages ? 'display: none;' : ''}">
                                            <label class="form-label" style="font-size: 14px; font-weight: 600; margin-bottom: 12px; display: block;">Chọn CV ứng tuyển <span style="color: var(--color-error);">*</span></label>
                                            <div id="cvOptionsContainer" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(80px, 1fr)); gap: 12px;">
                                                <c:if test="${not empty profile.cvImages}">
                                                    <c:forEach items="${cvList}" var="cvUrl" varStatus="status">
                                                        <c:set var="isImage" value="${fn:endsWith(fn:toLowerCase(cvUrl), '.jpg') || fn:endsWith(fn:toLowerCase(cvUrl), '.jpeg') || fn:endsWith(fn:toLowerCase(cvUrl), '.png') || fn:endsWith(fn:toLowerCase(cvUrl), '.gif')}" />
                                                        <c:set var="isActive" value="${status.index == 0}" />
                                                        <div class="cv-option" onclick="selectCv(this, '${cvUrl}')" style="position: relative; border: 2px solid ${isActive ? 'var(--primary)' : 'var(--border-color)'}; box-shadow: ${isActive ? '0 0 0 2px var(--primary)' : 'none'}; border-radius: 8px; overflow: hidden; background: rgba(255,255,255,0.05); padding: 2px; cursor: pointer; transition: all var(--transition-fast); height: 90px;">
                                                            <c:choose>
                                                                <c:when test="${isImage}">
                                                                    <img src="${cvUrl}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 6px;" alt="CV">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div style="width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; background: rgba(0,0,0,0.1); border-radius: 6px; color: var(--text-muted);">
                                                                        <span style="font-size: 24px;">📄</span>
                                                                        <span style="font-size: 10px; font-weight: 500;">Tài liệu CV</span>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div style="position: absolute; bottom: 4px; right: 4px; background: rgba(0,0,0,0.6); color: #fff; border-radius: 50%; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: bold;">${status.index + 1}</div>
                                                        </div>
                                                    </c:forEach>
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Nút tải CV mới lên hồ sơ -->
                                        <div style="margin-bottom: 20px;">
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="document.getElementById('ajaxCvFile').click();" style="width: 100%; gap: 6px; padding: 8px 12px; font-size: 13px;">
                                                <span>➕</span> Tải CV mới lên hồ sơ năng lực
                                            </button>
                                            <input type="file" id="ajaxCvFile" accept="image/*,application/pdf" style="display: none;" onchange="uploadCvViaAjax(this)">
                                        </div>

                                        <div class="form-group" style="margin-bottom: 24px;">
                                            <label class="form-label" for="coverLetter">Thư giới thiệu (Không bắt buộc)</label>
                                            <textarea id="coverLetter" name="coverLetter" class="form-control" placeholder="Viết một vài dòng tự giới thiệu ngắn về kỹ năng, kinh nghiệm của bạn..."></textarea>
                                        </div>

                                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">Xác nhận nộp hồ sơ</button>
                                    </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card" style="text-align: center; padding: 40px;">
                            <span style="font-size: 32px;">🚫</span>
                            <h3 style="font-size: 18px; font-weight: 700; margin-top: 16px;">Tài khoản không phù hợp</h3>
                            <p style="font-size: 14px; color: var(--text-muted); margin-top: 8px;">Chức năng nộp hồ sơ ứng tuyển chỉ dành riêng cho tài khoản **Ứng viên / Nghệ sĩ**.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Scripts for CV selection and upload -->
    <script>
        function validateApplicationForm() {
            var resumeUrl = document.getElementById('resumeUrl').value;
            if (!resumeUrl || resumeUrl.trim() === '') {
                alert('Vui lòng chọn hoặc tải lên một CV trước khi nộp hồ sơ!');
                return false;
            }
            return true;
        }

        function selectCv(element, cvUrl) {
            // Điền URL vào trường input
            document.getElementById('resumeUrl').value = cvUrl;
            
            // Xóa highlight cũ
            var options = document.querySelectorAll('.cv-option');
            options.forEach(function(opt) {
                opt.style.borderColor = 'var(--border-color)';
                opt.style.boxShadow = 'none';
            });
            
            // Highlight tệp được chọn
            element.style.borderColor = 'var(--primary)';
            element.style.boxShadow = '0 0 0 2px var(--primary)';
        }

        function uploadCvViaAjax(input) {
            if (!input.files || input.files[0] === undefined) return;
            
            var file = input.files[0];
            var formData = new FormData();
            formData.append("cvFile", file);
            
            // Trạng thái đang tải
            var btn = document.querySelector('[onclick="document.getElementById(\'ajaxCvFile\').click();"]');
            var originalText = btn.innerHTML;
            btn.innerHTML = '⏳ Đang tải lên...';
            btn.disabled = true;
            
            fetch('${pageContext.request.contextPath}/candidate/profile/upload-cv-ajax', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                
                if (data.success) {
                    var cvUrl = data.cvUrl;
                    
                    // 1. Điền URL vào ô input
                    document.getElementById('resumeUrl').value = cvUrl;
                    
                    // 2. Hiển thị danh sách nếu ban đầu ẩn
                    var formGroup = document.getElementById('cvSelectionFormGroup');
                    formGroup.style.display = 'block';
                    
                    // 3. Thêm tệp vừa tải vào danh sách
                    var container = document.getElementById('cvOptionsContainer');
                    var optionsCount = container.querySelectorAll('.cv-option').length;
                    
                    var newOption = document.createElement('div');
                    newOption.className = 'cv-option';
                    newOption.style.position = 'relative';
                    newOption.style.border = '2px solid var(--border-color)';
                    newOption.style.borderRadius = '8px';
                    newOption.style.overflow = 'hidden';
                    newOption.style.background = 'rgba(255,255,255,0.05)';
                    newOption.style.padding = '2px';
                    newOption.style.cursor = 'pointer';
                    newOption.style.transition = 'all var(--transition-fast)';
                    newOption.style.height = '90px';
                    newOption.onclick = function() { selectCv(this, cvUrl); };
                    
                    var isImage = cvUrl.match(/\.(jpeg|jpg|gif|png)$/i) != null;
                    var innerHtml = '';
                    if (isImage) {
                        innerHtml = '<img src="' + cvUrl + '" style="width: 100%; height: 100%; object-fit: cover; border-radius: 6px;" alt="CV">';
                    } else {
                        innerHtml = '<div style="width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; background: rgba(0,0,0,0.1); border-radius: 6px; color: var(--text-muted);"><span style="font-size: 24px;">📄</span><span style="font-size: 10px; font-weight: 500;">Tài liệu CV</span></div>';
                    }
                    innerHtml += '<div style="position: absolute; bottom: 4px; right: 4px; background: rgba(0,0,0,0.6); color: #fff; border-radius: 50%; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: bold;">' + (optionsCount + 1) + '</div>';
                    
                    newOption.innerHTML = innerHtml;
                    container.appendChild(newOption);
                    
                    // 4. Chọn ngay tệp này
                    selectCv(newOption, cvUrl);
                    
                    alert('Đã tải CV lên hồ sơ năng lực thành công!');
                } else {
                    alert('Tải lên thất bại: ' + data.message);
                }
            })
            .catch(error => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                console.error(error);
                alert('Có lỗi xảy ra trong quá trình tải lên.');
            });
        }
    </script>
</body>
</html>
